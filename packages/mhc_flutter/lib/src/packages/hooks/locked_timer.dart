import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'typedefs.dart';

LockedTimerController useLockedTimer({
  required Duration regularTimeout,
  Duration? initialTimeout,
  Duration? updateInterval,
  HookKeys keys,
}) =>
    use(
      _LockedTimerHook(
        keys: keys,
        regularTimeout: regularTimeout,
        initialTimeout: initialTimeout,
        updateInterval: updateInterval,
      ),
    );

class _LockedTimerHook extends Hook<LockedTimerController> {
  const _LockedTimerHook({
    super.keys,
    this.initialTimeout,
    required this.regularTimeout,
    Duration? updateInterval,
  }) : updateInterval = updateInterval ?? const Duration(milliseconds: 499);

  final Duration? initialTimeout;
  final Duration regularTimeout;
  final Duration updateInterval;

  @override
  _LockedTimerHookState createState() => _LockedTimerHookState();
}

class _LockedTimerHookState
    extends HookState<LockedTimerController, _LockedTimerHook> {
  late LockedTimerController _controller;
  late Timer _timer;

  DateTime? _beginTime;
  DateTime? _endTime;
  Duration? _remains;

  bool _completed = true;

  @override
  void initHook() {
    super.initHook();
    _controller = LockedTimerController._(this);
    _timer = Timer.periodic(hook.updateInterval, _timerListener);
    if (hook.initialTimeout != null) {
      assert(
        !hook.initialTimeout!.isNegative,
        'initialTimeout не может быть отрицательным',
      );
      _resetTimer(hook.initialTimeout);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  LockedTimerController build(BuildContext context) => _controller;

  void _computeRemains() {
    _completed = DateTime.now().isAfter(_endTime!);
    _remains = !_completed ? _endTime!.difference(DateTime.now()) : null;
  }

  void _timerListener(Timer timer) {
    if (_beginTime == null || _endTime == null) {
      return;
    }
    setState(_computeRemains);
  }

  void _resetTimer([Duration? duration]) {
    duration ??= hook.regularTimeout;
    assert(!duration.isNegative, 'duration не может быть отрицательным');
    _completed = false;
    _beginTime = DateTime.now();
    _endTime = _beginTime!.add(duration);
    _remains = _endTime!.difference(_beginTime!);
  }

  @override
  String? get debugLabel => 'useLockedTimer';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('completed', _completed));
    properties.add(DiagnosticsProperty<DateTime>('beginTime', _beginTime));
    properties.add(DiagnosticsProperty<DateTime>('endTime', _endTime));
    properties.add(DiagnosticsProperty<Duration>('remains', _remains));
  }
}

class LockedTimerController {
  const LockedTimerController._(this._state);

  final _LockedTimerHookState _state;

  Duration? get remains => _state._remains;

  void resetTimer([Duration? duration]) => _state._resetTimer(duration);
}
