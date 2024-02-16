import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'storage_key.dart';

typedef StorageKeyBuilder<T> = StorageKey<T> Function(
  String key,
  Storage storage,
);

abstract class Storage {
  Storage();

  final _keys = <String, StorageKey<dynamic>>{};

  Future<void> reset() async {
    for (final key in _keys.values) {
      await key.delete();
    }
  }

  @protected
  K keyCustom<T, K extends StorageKey<T>>(
    String key,
    StorageKeyBuilder<T> keyBuilder,
  ) =>
      _keys.putIfAbsent(key, () => keyBuilder(key, this)) as K;

  @protected
  StorageKey<T> key<T>(String key) => keyCustom(key, defaultKeyBuilder<T>);

  @protected
  Future<bool> exists(String key);

  @protected
  Future<T?> get<T>(String key, {T? defaultValue});

  @protected
  Future<void> set<T>(String key, T value);

  @protected
  Future<void> delete(String key);

  @protected
  Stream<T?> watch<T>(String key);

  static StorageKey<T> defaultKeyBuilder<T>(String key, Storage storage) =>
      StorageKey<T>(key, storage);
}
