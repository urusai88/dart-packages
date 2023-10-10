import 'package:meta/meta.dart';

part 'storage_key.dart';

abstract class Storage {
  Storage();

  final _keys = <String, StorageKey>{};

  Future<void> reset() async {
    for (final key in _keys.values) {
      await key.delete();
    }
  }

  @protected
  StorageKey<T> key<T>(String key) {
    return _keys.putIfAbsent(key, () {
      return StorageKey<T>(key, this);
    }) as StorageKey<T>;
  }

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
}
