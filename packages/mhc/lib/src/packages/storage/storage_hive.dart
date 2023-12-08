import 'package:hive/hive.dart';

import 'storage.dart';

class StorageHive extends Storage {
  StorageHive({required this.box});

  final Box<dynamic> box;

  @override
  Future<bool> exists(String key) => Future<bool>.value(box.containsKey(key));

  @override
  Future<T?> get<T>(String key, {T? defaultValue}) =>
      Future<T?>.value(box.get(key, defaultValue: defaultValue) as T?);

  @override
  Future<void> set<T>(String key, T value) => box.put(key, value);

  @override
  Future<void> delete(String key) => box.delete(key);

  @override
  Stream<T?> watch<T>(String key) =>
      box.watch(key: key).map((e) => e.value as T?);
}
