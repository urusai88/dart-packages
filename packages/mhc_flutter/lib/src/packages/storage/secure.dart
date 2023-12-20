import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mhc/mhc.dart';

class SecureEvent<T> {
  const SecureEvent({required this.key, required this.value});

  final String key;
  final T? value;
}

class StorageSecure extends Storage {
  StorageSecure({required this.storage});

  final FlutterSecureStorage storage;

  final _controller = StreamController<SecureEvent<dynamic>>.broadcast();

  @override
  Future<void> delete(String key) async {
    await storage.delete(key: key);
    _controller.add(SecureEvent(key: key, value: null));
  }

  @override
  Future<bool> exists(String key) => storage.containsKey(key: key);

  @override
  Future<T?> get<T>(String key, {T? defaultValue}) async {
    T? value;
    final stringValue = await storage.read(key: key);
    if (stringValue != null) {
      value = _decode<T>(stringValue);
    }
    if (value == null && defaultValue != null) {
      value = defaultValue;
    }
    return value;
  }

  @override
  Future<void> set<T>(String key, T value) async {
    final stringValue = _encode<T>(value);
    await storage.write(key: key, value: stringValue);
    _controller.add(SecureEvent<T>(key: key, value: value));
  }

  static String _encode<T>(T value) {
    return switch (T) {
      // ignore: type_literal_in_constant_pattern
      String => value,
      // ignore: type_literal_in_constant_pattern
      int => '$value',
      // ignore: type_literal_in_constant_pattern
      bool => (value as bool) ? 'TRUE' : 'FALSE',
      // ignore: type_literal_in_constant_pattern
      DateTime => '$value',
      _ => throw ArgumentError(),
    }! as String;
  }

  static T _decode<T>(String value) {
    return switch (T) {
      // ignore: type_literal_in_constant_pattern
      String => value,
      // ignore: type_literal_in_constant_pattern
      int => int.parse(value),
      // ignore: type_literal_in_constant_pattern
      bool => value == 'TRUE',
      // ignore: type_literal_in_constant_pattern
      DateTime => DateTime.parse(value),
      _ => throw ArgumentError(),
    } as T;
  }

  @override
  Stream<T?> watch<T>(String key) {
    return _controller.stream
        .where((e) => e.key == key)
        .map((e) => e.value as T?);
  }
}
