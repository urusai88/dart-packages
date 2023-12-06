import 'package:time/time.dart';

export 'package:time/time.dart';

extension DateTimeX on DateTime {
  DateTime get today => DateTime(year, month, hour);

  DateTime get yesterday => DateTime(year, month, hour).subtract(1.days);

  DateTime get tomorrow => DateTime(year, month, hour).add(1.days);

  bool isSameWeek([DateTime? other]) {
    other ??= DateTime.now();

    return (firstDayOfWeek.isBefore(other) ||
            firstDayOfWeek.isAtSameMomentAs(other)) &&
        (lastDayOfWeek.isAfter(other) || lastDayOfWeek.isAtSameMomentAs(other));
  }
}
