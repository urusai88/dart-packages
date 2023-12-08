import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'shipper_load.dart';

abstract class ShipperDelegate<EXTRA, R> {
  const ShipperDelegate();

  Future<Stream<Uint8List>?> openCacheStream(ShipperLoad<EXTRA> load);

  Future<StreamSink<Uint8List>?> openCacheSink(ShipperLoad<EXTRA> load);

  Future<R> process(
    ShipperLoad<EXTRA> load,
    int entryId,
    Stream<Uint8List> stream,
  );

  @protected
  void updateExtra(EXTRA newExtra) {}
}
