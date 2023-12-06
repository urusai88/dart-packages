import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../api.dart';

class FactoryGroup<ErrorT> {
  const FactoryGroup({
    required this.empty,
    required this.string,
    required this.json,
  });

  final EmptyFactory<ErrorT> empty;
  final StringFactory<ErrorT> string;
  final JsonFactory<ErrorT> json;
}

class FactoryConfig<ErrorT> {
  FactoryConfig({required this.errorGroup});

  var _map =
      IMap<Type, JsonFactory<dynamic>>(const <Type, JsonFactory<dynamic>>{});

  JsonFactory<ErrorT>? errorJsonFactory;
  StringFactory<ErrorT>? errorStringFactory;
  ListFactory<ErrorT, ErrorT>? errorListFactory;

  IMap<Type, JsonFactory<dynamic>> get map => _map;

  FactoryGroup<ErrorT> errorGroup;

  void add<T>(JsonFactory<T> factory) {
    _map = _map.add(T, factory);
  }

  JsonFactory<T>? get<T>() {
    if (!_map.containsKey(T)) {
      return null;
    }
    return _map[T]! as JsonFactory<T>;
  }

  bool contains<T>() => _map.containsKey(T);
}
