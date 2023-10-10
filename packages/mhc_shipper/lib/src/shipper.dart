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

typedef UpdateExtraCallback<ExtraT> = ExtraT Function(ExtraT extra);

abstract class Shipper<ExtraT, ResultT,
        EntryT extends ShipperEntryBase<ExtraT, ResultT, EntryT>>
    extends StateNotifier<ShipperState<ExtraT, ResultT, EntryT>> {
  Shipper({
    required ShipperOptions options,
    required ShipperDelegate<ExtraT, ResultT> delegate,
  })  : _options = options,
        _delegate = delegate,
        super(ShipperState<ExtraT, ResultT, EntryT>.empty());

  final ShipperOptions _options;
  final ShipperDelegate<ExtraT, ResultT> _delegate;

  Logger get _logger => Logger('Shipper');

  final _controller =
      StreamController<ShipperEvent<ExtraT, ResultT, EntryT>>.broadcast();

  Stream<ShipperEvent<ExtraT, ResultT, EntryT>> get events =>
      _controller.stream;

  @override
  @protected
  Stream<ShipperState<ExtraT, ResultT, EntryT>> get stream => super.stream;

  @override
  void dispose() {
    super.dispose();
    unawaited(_controller.close());
  }

  List<ShipperEntryBase> addToQueue(Iterable<ShipperLoad<ExtraT>> files) {
    final notifiers = <ShipperEntryBase>[];
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
      } catch (e) {
        print(e);
      }
    }
    Future(_processQueue);
    return notifiers;
  }

  Future<void> removeFailureEntry(Iterable<int> ids) async {
    if (ids.isEmpty) {
      return;
    }
    for (final id in ids) {
      final splitter = state.splitters[id];
      if (splitter != null) {
        await splitter.close();
        state = state.copyWith(splitters: state.splitters.remove(id));
      }
      state = state.copyWith(entries: state.entries.remove(id));
    }
  }

  void restartFailureEntries() {
    restartFailureEntry(state.entriesFailure.map((e) => e.id));
  }

  void restartFailureEntry(Iterable<int> ids) {
    if (ids.isEmpty) {
      return;
    }
    for (final id in ids) {
      _reportStatus(id, const ShipperEntryStatus.inQueue());
    }
    _processQueue();
  }

  EntryT? getEntry(int id) => state.entries[id];

  void updateExtra(int id, UpdateExtraCallback<ExtraT> fn) {
    final entry = getEntry(id);
    if (entry == null) {
      return;
    }
    final newExtra = fn(entry.load.extra);
    final newEntry = entry.withExtra(newExtra);
    // final newExtra = entry.withExtra(fn(entry.load.extra));
    state = state.copyWith(
      entries: state.entries.add(id, newEntry),
    );
  }

  bool _willExceed(ShipperEntryBase entry) {
    if (_options.maxOneTimeProcessing == null) {
      return false;
    }
    return state.processingBytes + entry.load.size >
        _options.maxOneTimeProcessing!;
  }

  void _processQueue() {
    if (state.entriesInQueue.isEmpty) {
      return;
    }
    final entry = state.entriesInQueue.first;
    final willExceed = _willExceed(entry);
    if (willExceed) {
      return;
    }
    state = state.modifyProcessingBytes(entry.load.size);
    _reportStatus(entry.id, const ShipperEntryStatus.processingZero());
    Future(() async => _processEntry(entry));
    _processQueue();
  }

  Future<void> _processEntry(EntryT entry) async {
    _logger.fine('entry ${entry.id} _processEntry');
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

    // cache block
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
      _logger.warning('Блок обработки кэша:\n$e\n$s');
    }

    readStream ??= splitter.split();

    try {
      final result = await _delegate.process(entry.load, entry.id, readStream);
      _reportStatus(entry.id, ShipperEntryStatus.completed(result));
      _controller.add(
        ShipperEvent<ExtraT, ResultT, EntryT>.completed(
          entry: entry,
          result: result,
        ),
      );
      await splitter.close();
      state = state.copyWith(splitters: state.splitters.remove(entry.id));
    } catch (e, s) {
      _logger.warning('Блок загрузки:\n$e\n$s');
      _reportStatus(entry.id, ShipperEntryStatus.failure(e, s));
      _controller.add(
        ShipperEvent<ExtraT, ResultT, EntryT>.failure(entry: entry),
      );
    } finally {
      state = state.modifyProcessingBytes(-entry.load.size);
      _processQueue();
    }
  }

  void _reportStatus(int id, ShipperEntryStatus<ResultT> status) {
    _logger.info('entry $id status => $status');
    state = state.copyWith(
      entries: state.entries.add(id, state.entries[id]!.withStatus(status)),
    );
  }

  @protected
  EntryT createEntry({
    required int id,
    required ShipperLoad<ExtraT> load,
    required ShipperEntryStatus<ResultT> status,
  });
}
