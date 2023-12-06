import 'dart:async';

bool checkMap<K, V>(Map<dynamic, dynamic> map) {
  for (final key in map.keys) {
    if (key is! K && map[key] is! V) {
      return false;
    }
  }
  return true;
}

void capture(dynamic Function() fn, [String? name]) {
  final sw = Stopwatch()..start();
  final result = fn();
  sw.stop();
  Zone.current.print('${name ?? result} ${sw.elapsedMilliseconds}');
}

void main() {
  // test('test', () {}, skip: true);
  // final map = <dynamic, dynamic>{};
  // final rand = Random();
  // for (var i = 0; i < 1000000; ++i) {
  //   map['djqidjqq$i'] = rand.nextInt(1000000);
  // }
  //
  // capture(() => Map<String, dynamic>.from(map), 'base from');
  // capture(() => checkMap<String, dynamic>(map), 'check map');
  // capture(() => castFor<String, dynamic>(map), 'cast for');
  // capture(() => castNative<String, dynamic>(map), 'cast native');
  // capture(() => cast<String, dynamic>(map), 'cast');
  //
  // capture(() => enumerateKeys(map), 'enumerate keys');
  // capture(() => enumerateKeysCast<String, dynamic>(map), 'enumerate keys cast');
  // capture(() => enumerateValues(map), 'enumerate values');
  // capture(
  //     () => enumerateValuesCast<String, dynamic>(map), 'enumerate values cast');

  // test('test cast', () {
  //   final result = map.cast<String, dynamic>();
  //   expect(result, isA<JSON>());
  //   print(result.runtimeType);
  // });
  // test('test from', () {
  //   final result = JSON.from(map);
  //   expect(result, isA<JSON>());
  //   print(result.runtimeType);
  // });
}
