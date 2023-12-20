import 'dart:async';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:state_notifier/state_notifier.dart';

import 'shipper_delegate.dart';
import 'shipper_entry.dart';
import 'shipper_entry_status.dart';
import 'shipper_event.dart';
import 'shipper_load.dart';
import 'shipper_options.dart';
import 'shipper_state.dart';

typedef UpdateExtraCallback<EXTRA> = EXTRA Function(EXTRA extra);

abstract class Shipper<EXTRA, R,
        ENTRY extends ShipperEntryBase<EXTRA, R, ENTRY>>
    extends StateNotifier<ShipperState<EXTRA, R, ENTRY>> {
  Shipper({
    required ShipperOptions options,
    required ShipperDelegate<EXTRA, R> delegate,
  })  : _options = options,
        _delegate = delegate,
        super(ShipperState<EXTRA, R, ENTRY>.empty());

  final ShipperOptions _options;
  final ShipperDelegate<EXTRA, R> _delegate;

  final _logger = Logger('Shipper');

  final _controller =
      StreamController<ShipperEvent<EXTRA, R, ENTRY>>.broadcast();

  Stream<ShipperEvent<EXTRA, R, ENTRY>> get events => _controller.stream;

  @override
  @protected
  Stream<ShipperState<EXTRA, R, ENTRY>> get stream => super.stream;

  @override
  void dispose() {
    super.dispose();
    unawaited(_controller.close());
  }

  List<ShipperEntryBase<EXTRA, R, ENTRY>> addToQueue(
    Iterable<ShipperLoad<EXTRA>> files,
  ) {
    _logger.info('${files.length} файлов добавлено в очередь');
    final notifiers = <ShipperEntryBase<EXTRA, R, ENTRY>>[];
    for (final file in files) {
      final entry = createEntry(
        id: state.id,
        load: file,
        status: const ShipperEntryStatus.inQueue(),
      );
      notifiers.add(entry);
      try {
        state = state.copyWith(entries: state.entries.add(entry.id, entry));
        state = state.incrementId();
      } catch (e, s) {
        _logger.warning('', e, s);
      }
    }
    Future(_processQueue);
    return notifiers;
  }

  Future<void> removeFailureEntry(Iterable<int> ids) async {
    for (final id in ids) {
      final splitter = state.splitters[id];
      if (splitter != null) {
        await splitter.close();
        state = state.copyWith(splitters: state.splitters.remove(id));
      }
      state = state.copyWith(entries: state.entries.remove(id));
    }
  }

  void restartFailureEntries() =>
      restartFailureEntry(state.entriesFailure.map((e) => e.id));

  void restartFailureEntry(Iterable<int> ids) {
    if (ids.isEmpty) {
      return;
    }
    for (final id in ids) {
      _reportStatus(id, const ShipperEntryStatus.inQueue());
    }
    _processQueue();
  }

  ENTRY? getEntry(int id) => state.entries[id];

  void updateExtra(int id, UpdateExtraCallback<EXTRA> fn) {
    final entry = getEntry(id);
    if (entry == null) {
      return;
    }
    final newExtra = fn(entry.load.extra);
    final newEntry = entry.withExtra(newExtra);
    state = state.copyWith(
      entries: state.entries.add(id, newEntry),
    );
  }

  bool _willExceed(ShipperEntryBase<EXTRA, R, ENTRY> entry) {
    if (_options.maxOneTimeProcessingBytes == null) {
      return false;
    }
    return state.processingBytes + entry.load.size >
        _options.maxOneTimeProcessingBytes!;
  }

  void _processQueue() {
    _logger.info('В очереди ${state.entriesInQueue.length}');
    if (state.entriesInQueue.isEmpty) {
      return;
    }
    final entry = state.entriesInQueue.first;
    final willExceed = _willExceed(entry);
    if (willExceed) {
      _logger.info(
        'Не хватает буфера для ${entry.id} +${entry.load.size} ${state.processingBytes}/${_options.maxOneTimeProcessingBytes}',
      );
      return;
    }
    _logger.info('Загрузка ${entry.id}');
    state = state.modifyProcessingBytes(entry.load.size);
    _reportStatus(entry.id, const ShipperEntryStatus.processingZero());
    Future(() async => _processEntry(entry));
    _processQueue();
  }

  Future<void> _processEntry(ENTRY entry) async {
    _logger.fine('entry ${entry.id} processing');
    final splitterOutput = Output<StreamSplitter<Uint8List>>();
    state = state.copyWith(
      splitters: state.splitters.putIfAbsent(
        entry.id,
        () => StreamSplitter<Uint8List>(entry.load.readStream),
        previousValue: splitterOutput,
      ),
    );
    final splitter = splitterOutput.value!;
    Stream<Uint8List>? readStream;

    try {
      final cacheStream = await _delegate.openCacheStream(entry.load);
      final cacheSink = await _delegate.openCacheSink(entry.load);

      if (cacheStream == null) {
        _logger.fine('entry ${entry.id} Кэш не найден');
        if (cacheSink != null) {
          _logger.fine('entry ${entry.id} Кэш записывается');
          await cacheSink.addStream(splitter.split());
          await cacheSink.close();
          _logger.fine('entry ${entry.id} Кэш записан');
        } else {
          _logger.fine('entry ${entry.id} Кэш не может быть записан');
        }
      } else {
        _logger.fine('entry ${entry.id} Кэш найден');
        readStream = cacheStream;
      }
    } catch (e, s) {
      _logger.warning('Блок обработки кэша', e, s);
    }

    readStream ??= splitter.split();

    try {
      final result = await _delegate.process(entry.load, entry.id, readStream);
      _reportStatus(entry.id, ShipperEntryStatus.completed(result));
      _controller.add(
        ShipperEvent<EXTRA, R, ENTRY>.completed(
          entry: entry,
          result: result,
        ),
      );
      await splitter.close();
      state = state.copyWith(splitters: state.splitters.remove(entry.id));
    } catch (e, s) {
      _logger.warning('Блок загрузки', e, s);
      _reportStatus(entry.id, ShipperEntryStatus.failure(e, s));
      _controller.add(
        ShipperEvent<EXTRA, R, ENTRY>.failure(entry: entry),
      );
    } finally {
      state = state.modifyProcessingBytes(-entry.load.size);
      _processQueue();
    }
  }

  void _reportStatus(int id, ShipperEntryStatus<R> status) {
    _logger.info('entry $id status => $status');
    state = state.copyWith(
      entries: state.entries.add(id, state.entries[id]!.withStatus(status)),
    );
  }

  @protected
  ENTRY createEntry({
    required int id,
    required ShipperLoad<EXTRA> load,
    required ShipperEntryStatus<R> status,
  });
}
