import '../../core.dart';

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
}

extension ListXHasId<H, T extends HasId<H>> on List<T> {
  bool hasId(H id) => containsWhere((e) => e.id == id);

  T whereId(H id) => firstWhere((e) => e.id == id);

  T? whereIdOrNull(H id) => firstWhereOrNull((e) => e.id == id);

  void removeWhereId(H id) => removeWhere((e) => e.id == id);
}
