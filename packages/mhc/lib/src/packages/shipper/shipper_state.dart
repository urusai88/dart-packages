import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'shipper_entry.dart';
import 'shipper_entry_status.dart';

class ShipperState<EXTRA, R, ENTRY extends ShipperEntryBase<EXTRA, R, ENTRY>> {
  const ShipperState({
    this.id = 1,
    this.processingBytes = 0,
    required this.entries,
    required this.splitters,
  });

  ShipperState.empty()
      : id = 1,
        processingBytes = 0,
        // ignore: prefer_const_literals_to_create_immutables
        entries = IMapConst<int, ENTRY>({}),
        splitters = const IMapConst<int, StreamSplitter<Uint8List>>({});

  final int id;
  final int processingBytes;
  final IMap<int, ENTRY> entries;
  final IMap<int, StreamSplitter<Uint8List>> splitters;

  Iterable<ENTRY> get entriesInQueue =>
      entries.values.where((e) => e.status is ShipperEntryStatusInQueue<R>);

  Iterable<ENTRY> get entriesProcessing =>
      entries.values.where((e) => e.status is ShipperEntryStatusProcessing<R>);

  Iterable<ENTRY> get entriesFailure =>
      entries.values.where((e) => e.status is ShipperEntryStatusFailure<R>);

  Iterable<ENTRY> get entriesCompleted =>
      entries.values.where((e) => e.status is ShipperEntryStatusCompleted<R>);

  ShipperState<EXTRA, R, ENTRY> incrementId() => copyWith(id: id + 1);

  ShipperState<EXTRA, R, ENTRY> modifyProcessingBytes(int count) =>
      copyWith(processingBytes: processingBytes + count);

  ShipperState<EXTRA, R, ENTRY> copyWith({
    int? id,
    int? processingBytes,
    IMap<int, ENTRY>? entries,
    IMap<int, StreamSplitter<Uint8List>>? splitters,
  }) =>
      ShipperState(
        id: id ?? this.id,
        processingBytes: processingBytes ?? this.processingBytes,
        entries: entries ?? this.entries,
        splitters: splitters ?? this.splitters,
      );
}
