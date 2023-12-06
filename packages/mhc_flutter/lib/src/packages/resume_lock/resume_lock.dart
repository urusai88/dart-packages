import 'dart:async';

import 'package:flutter/widgets.dart';

import 'resume_lock_action.dart';
import 'resume_lock_delegate.dart';

export 'resume_lock_action.dart';
export 'resume_lock_delegate.dart';

typedef LockerRouteBuilder<T> = Route<T> Function(Widget child);

abstract interface class ResumeLockState {
  void lock();

  void unlock();
}

class ResumeLock extends StatefulWidget {
  const ResumeLock({
    super.key,
    required this.delegate,
    required this.navigatorKey,
    required this.lockerBuilder,
    required this.lockerRouteBuilder,
    required this.child,
  });

  final ResumeLockDelegate delegate;
  final GlobalKey<NavigatorState> navigatorKey;

  final WidgetBuilder lockerBuilder;
  final LockerRouteBuilder<dynamic> lockerRouteBuilder;
  final Widget child;

  @override
  State<ResumeLock> createState() => _ResumeLockState();

  static ResumeLockState of(BuildContext context) =>
      context.findAncestorStateOfType<_ResumeLockState>()!;
}

class _ResumeLockState extends State<ResumeLock>
    with WidgetsBindingObserver
    implements ResumeLockState {
  var _locked = false;

  NavigatorState? get navigator => widget.navigatorKey.currentState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        widget.delegate.pause();
      case AppLifecycleState.resumed:
        switch (await widget.delegate.action(context)) {
          case ResumeLockActionNone():
            return;
          case ResumeLockActionLock():
            lock();
        }
      case _:
    }
  }

  @override
  void lock() {
    if (_locked || navigator == null) {
      return;
    }
    final child =
        PopScope(canPop: false, child: Builder(builder: widget.lockerBuilder));
    final route = widget.lockerRouteBuilder(child);
    setState(() => _locked = true);
    unawaited(navigator!.push(route));
  }

  @override
  void unlock() {
    if (!_locked || navigator == null) {
      return;
    }
    setState(() => _locked = false);
    navigator!.pop();
    widget.delegate.unlocked();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
