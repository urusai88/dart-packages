import '../../core.dart';

export 'package:fast_immutable_collections/fast_immutable_collections.dart';

extension IListX<T> on IList<T> {
  bool containsWhere(bool Function(T e) test) => indexWhere(test) != -1;

  IList<T> insertBetween(T Function() valueBuilder) =>
      (unlock..insertBetween(valueBuilder)).lock;

  bool hasIndex(int index) {
    if (index == -1 || isEmpty) {
      return false;
    }
    return length > index;
  }
}

extension IListXHasId<H, T extends HasId<H>> on IList<T> {
  bool hasId(H id) => containsWhere((e) => e.id == id);

  IList<T> removeWhereId(H id) => removeWhere((e) => e.id == id);
}
