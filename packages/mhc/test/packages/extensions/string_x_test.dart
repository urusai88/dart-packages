import 'package:mhc/mhc.dart';
import 'package:test/test.dart';

void main() {
  void Function() rangeError(String string, int index) =>
      () => expect(() => ''.upChar(index, throwError: true), throwsRangeError);

  group('upChar/lowChar', () {
    test('strlen=0, i=0', () => expect(''.upChar(0), equals('')));
    test('strlen=0, i=1', () => expect(''.upChar(1), equals('')));
    test('strlen=0, i=1, throws', rangeError('', 1));
    test('strlen=0, i=-1, throws', rangeError('', -1));
    test('strlen=2, i=0', () => expect('hi'.upChar(0), equals('Hi')));
    test('strlen=2, i=1', () => expect('hi'.upChar(1), equals('hI')));
    test('strlen=2, i=2', () => expect('hi'.upChar(2), equals('hi')));
    test('strlen=2, i=-1 throws', rangeError('hi', -1));
  });

  group('getters', () {
    group('lastIndex', () {
      test('strlen=5', () => expect(''.lastIndex, 0));
      test('strlen=1', () => expect('_'.lastIndex, 0));
      test('strlen=5', () => expect('+___-'.lastIndex, 4));
    });

    group('firstChar', () {
      test('strlen=0', () => expect(''.firstChar, ''));
      test('strlen=1', () => expect('_'.firstChar, '_'));
      test('strlen=5', () => expect('+___-'.firstChar, '+'));
    });

    group('lastChar', () {
      test('strlen=0', () => expect(''.lastChar, ''));
      test('strlen=1', () => expect('_'.lastChar, '_'));
      test('strlen=5', () => expect('+___-'.lastChar, '-'));
    });
  });
}
