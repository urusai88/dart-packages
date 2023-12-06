import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

typedef ProcessingProvider
    = AutoDisposeFamilyNotifierProvider<ProcessingNotifier, bool, String>;

class ProcessingNotifier extends AutoDisposeFamilyNotifier<bool, String> {
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
  /// Рроверку на текущее состояние необходимо делать вручную
  Future<T> processManual<T>(AsyncValueGetter<T> fn) async {
    try {
      start();
      return await fn();
    } finally {
      stop();
    }
  }
}
