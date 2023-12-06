enum ChangeCase { up, low }

extension StringX on String {
  int get lastIndex => isEmpty ? 0 : length - 1;

  String get firstChar => isEmpty ? '' : this[0];

  String get lastChar => isEmpty ? '' : this[lastIndex];

  bool hasIndex(int index) {
    if (index == -1) {
      return false;
    }
    return length > index;
  }

  /// Швыряет RangeError если строка пустая
  String upChar(int index, {bool throwError = false}) =>
      _changeCaseAtIndex(index, ChangeCase.up, throwError: throwError);

  /// Швыряет RangeError если строка пустая
  String lowChar(int index, {bool throwError = false}) =>
      _changeCaseAtIndex(index, ChangeCase.low, throwError: throwError);

  String _changeCaseAtIndex(
    int index,
    ChangeCase op, {
    bool throwError = false,
  }) {
    if (!hasIndex(index)) {
      return _returnOrThrowRangeError(index, throwError: throwError);
    }
    final c = switch (op) {
      ChangeCase.up => this[index].toUpperCase(),
      ChangeCase.low => this[index].toLowerCase(),
    };
    return substring(0, index) + c + substring(index + 1);
  }

  String _returnOrThrowRangeError(int index, {required bool throwError}) {
    if (throwError && !hasIndex(index)) {
      throw RangeError.range(index, 0, length - 1);
    }
    return this;
  }
}
