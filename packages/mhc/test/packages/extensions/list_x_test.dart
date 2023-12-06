import 'package:mhc/mhc.dart';
import 'package:test/test.dart';

void main() {
  final list = <int>[1, 3, 5];
  final listWithInserts = [1, 0, 3, 0, 5];
  const numberInList = 3;
  const numberNotInList = 2;
  const numberInsert = 0;

  group('list_x ', () {
    test('containsWhere', () {
      expect(list.containsWhere((i) => i == numberInList), isTrue);
      expect(list.containsWhere((i) => i == numberNotInList), isFalse);
    });

    test('insertBetween', () {
      final copy = List.of(list)..insertBetween(() => numberInsert);
      expect(copy, equals(listWithInserts));
    });

    test('hasIndex', () {
      expect(list.hasIndex(-1), isFalse);
      expect(list.hasIndex(0), isTrue);
      expect(list.hasIndex(1), isTrue);
      expect(list.hasIndex(2), isTrue);
      expect(list.hasIndex(3), isFalse);
    });
  });
}
