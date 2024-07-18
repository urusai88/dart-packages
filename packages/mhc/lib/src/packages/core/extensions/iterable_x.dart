extension IterableX<T> on Iterable<T> {
  bool get containsDuplicates {
    final namesExists = <T>[];
    for (final name in this) {
      if (namesExists.contains(name)) {
        return true;
      }
      namesExists.add(name);
    }
    return false;
  }
}
