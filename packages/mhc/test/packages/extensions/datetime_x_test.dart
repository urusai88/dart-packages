import 'package:mhc/mhc.dart';
import 'package:test/test.dart';

void main() {
  final now = DateTime.now();
  final week = now.weekday == 1 ? now + 1.days : now - 1.days;
  final notWeek = now.add(const Duration(days: 365));

  final testWekDay = now;
  final testWeekDaySuccess = [now, ...now.firstDayOfWeek.to(now.lastDayOfWeek)];
  final testWeekDayFailure = [
    notWeek,
    ...notWeek.firstDayOfWeek.to(notWeek.lastDayOfWeek),
  ];

  group('datetime_x', () {
    test('this week', () {
      expect(now.isSameWeek(week), isTrue);
      expect(now.isSameWeek(notWeek), isFalse);

      void testDaysForWeek(
        Iterable<DateTime> dateTimes, {
        required bool success,
      }) {
        for (final dateTime in dateTimes) {
          final same = testWekDay.isSameWeek(dateTime);
          final reason = '$dateTime';
          expect(same, equals(success), reason: reason);
        }
      }

      testDaysForWeek(testWeekDaySuccess, success: true);
      testDaysForWeek(testWeekDayFailure, success: false);
    });
  });
}
