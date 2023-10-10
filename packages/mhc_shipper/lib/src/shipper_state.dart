import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'shipper_entry.dart';
import 'shipper_entry_status.dart';

class ShipperState<ExtraT, ResultT,
    EntryT extends ShipperEntryBase<ExtraT, ResultT, EntryT>> {
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
        entries = IMapConst<int, EntryT>(<int, EntryT>{}),
        splitters = const IMapConst<int, StreamSplitter<Uint8List>>({});

  final int id;
  final int processingBytes;
  final IMap<int, EntryT> entries;
  final IMap<int, StreamSplitter<Uint8List>> splitters;

  Iterable<EntryT> get entriesInQueue =>
      entries.values.where((e) => e.status is ShipperEntryStatusInQueue);

  Iterable<EntryT> get entriesFailure =>
      entries.values.where((e) => e.status is ShipperEntryStatusFailure);

  ShipperState<ExtraT, ResultT, EntryT> incrementId() {
    return ShipperState(
      id: id + 1,
      processingBytes: processingBytes,
      entries: entries,
      splitters: splitters,
    );
  }

  ShipperState<ExtraT, ResultT, EntryT> modifyProcessingBytes(int count) {
    return ShipperState(
      id: id,
      processingBytes: processingBytes + count,
      entries: entries,
      splitters: splitters,
    );
  }

  ShipperState<ExtraT, ResultT, EntryT> copyWith({
    int? id,
    int? processingBytes,
    IMap<int, EntryT>? entries,
    IMap<int, StreamSplitter<Uint8List>>? splitters,
  }) {
    return ShipperState(
      id: id ?? this.id,
      processingBytes: processingBytes ?? this.processingBytes,
      entries: entries ?? this.entries,
      splitters: splitters ?? this.splitters,
    );
  }
}
