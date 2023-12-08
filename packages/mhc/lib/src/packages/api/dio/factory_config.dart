import '../../../../mhc.dart';

class FactoryGroup<ERR> {
  const FactoryGroup({
    required this.empty,
    required this.string,
    required this.json,
  });

  final EmptyFactory<ERR> empty;
  final StringFactory<ERR> string;
  final JsonFactory<ERR> json;
}

class FactoryConfig<ERR> {
  FactoryConfig({required this.errorGroup});

  var _map =
      IMap<Type, JsonFactory<dynamic>>(const <Type, JsonFactory<dynamic>>{});

  IMap<Type, JsonFactory<dynamic>> get map => _map;

  FactoryGroup<ERR> errorGroup;

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
