export 'package:collection/collection.dart';

extension ListX<T> on List<T> {
  bool containsWhere(bool Function(T e) test) => indexWhere(test) != -1;

  void insertBetween(T Function() valueBuilder) {
    for (var i = length - 1; i > 0; --i) {
      insert(i, valueBuilder());
    }
  }

  bool hasIndex(int index) {
    if (index == -1 || isEmpty) {
      return false;
    }
    return length > index;
  }

  bool check<R>() => every((item) => item is R);

  List<R>? castChecked<R>() => check<R>() ? List<R>.from(this) : null;
}
