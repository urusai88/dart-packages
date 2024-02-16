part of 'storage.dart';

class StorageKey<T> extends Equatable {
  const StorageKey(this.key, this.storage);

  final String key;
  final Storage storage;

  Future<bool> exists() => storage.exists(key);

  Future<T?> get({T? defaultValue}) =>
      storage.get<T>(key, defaultValue: defaultValue);

  Future<void> set(T value) => storage.set<T>(key, value);

  Future<void> delete() => storage.delete(key);

  Stream<T?> watch() => storage.watch<T>(key);

  @override
  List<Object?> get props => [key, storage];
}
