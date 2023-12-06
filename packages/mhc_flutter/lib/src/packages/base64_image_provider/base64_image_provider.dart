import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

@immutable
class Base64Image extends ImageProvider<Base64Image> {
  const Base64Image({required this.base64, this.scale = 1});

  static final _cache = <String, Uint8List>{};

  final String base64;

  final double scale;

  @override
  Future<Base64Image> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<Base64Image>(this);

  Future<ui.Codec> _loadAsync(
    Base64Image key, {
    required Uint8List bytes,
    required ImageDecoderCallback decode,
  }) async {
    assert(key == this);
    return decode(await ui.ImmutableBuffer.fromUint8List(bytes));
  }

  @override
  ImageStreamCompleter loadImage(Base64Image key, ImageDecoderCallback decode) {
    final i = base64.indexOf(',');
    final b64 = i == -1 ? base64 : base64.substring(i + 1);
    final bytes = _cache.putIfAbsent(
      b64,
      () => base64Decode(b64.trim().replaceAll('\n', '')),
    );

    return MultiFrameImageStreamCompleter(
      codec: Future(() async => _loadAsync(key, bytes: bytes, decode: decode)),
      scale: key.scale,
      debugLabel: 'Base64Image(${describeIdentity(base64)})',
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Base64Image &&
        other.base64 == base64 &&
        other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(base64, scale);
}
