import 'dart:typed_data';

class ShipperLoad<T> {
  const ShipperLoad({
    required this.readStream,
    required this.size,
    required this.extra,
  });

  final Stream<Uint8List> readStream;
  final int size;
  final T extra;

  ShipperLoad<T> copyWith({
    Stream<Uint8List>? readStream,
    int? size,
    T? extra,
  }) {
    return ShipperLoad<T>(
      readStream: readStream ?? this.readStream,
      size: size ?? this.size,
      extra: extra ?? this.extra,
    );
  }
}
