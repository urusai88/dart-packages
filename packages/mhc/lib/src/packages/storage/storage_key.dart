part of 'storage.dart';

@immutable
class StorageKey<T> {
  const StorageKey(this.key, this._storage);

  final String key;
  final Storage _storage;

  Future<bool> exists() => _storage.exists(key);

  Future<T?> get({T? defaultValue}) =>
      _storage.get<T>(key, defaultValue: defaultValue);

  Future<void> set(T value) => _storage.set<T>(key, value);

  Future<void> delete() => _storage.delete(key);

  Stream<T?> watch() => _storage.watch<T>(key);

  @override
  int get hashCode => Object.hash(key, _storage);

  @override
  bool operator ==(Object other) =>
      other is StorageKey<T> && other.key == key && other._storage == _storage;
}
