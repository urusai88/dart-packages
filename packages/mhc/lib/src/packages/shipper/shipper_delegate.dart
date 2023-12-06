import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'shipper_load.dart';

abstract class ShipperDelegate<ExtraT, ResultT> {
  const ShipperDelegate();

  Future<Stream<Uint8List>?> openCacheStream(ShipperLoad<ExtraT> load);

  Future<StreamSink<Uint8List>?> openCacheSink(ShipperLoad<ExtraT> load);

  Future<ResultT> process(
    ShipperLoad<ExtraT> load,
    int entryId,
    Stream<Uint8List> stream,
  );

  @protected
  void updateExtra(ExtraT newExtra) {}
}
