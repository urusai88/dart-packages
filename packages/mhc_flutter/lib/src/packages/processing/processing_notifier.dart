import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'processing_notifier.g.dart';

@Riverpod()
class Processing extends _$Processing {
  @override
  bool build(String arg) => false;

  void start() => state = true;

  void stop() => state = false;

  Future<void> processAuto(AsyncCallback fn) async {
    if (state) {
      return;
    }
    try {
      start();
      await fn();
    } finally {
      stop();
    }
  }

  /// Позволяет вернуть значение.
  /// Проверку на текущее состояние необходимо делать вручную
  Future<T> processManual<T>(AsyncValueGetter<T> fn) async {
    try {
      start();
      return await fn();
    } finally {
      stop();
    }
  }
}
