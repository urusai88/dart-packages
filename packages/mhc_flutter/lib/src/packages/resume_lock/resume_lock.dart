import 'dart:async';

import 'package:flutter/widgets.dart';

import 'resume_lock_action.dart';
import 'resume_lock_delegate.dart';

export 'resume_lock_action.dart';
export 'resume_lock_delegate.dart';

typedef LockerRouteBuilder<T> = Route<T> Function(Widget child);

abstract base class ResumeLock extends StatefulWidget {
  const ResumeLock({
    super.key,
    required this.delegate,
    required this.navigatorKey,
    this.locked = false,
    required this.child,
  });

  final ResumeLockDelegate delegate;
  final GlobalKey<NavigatorState> navigatorKey;
  final bool locked;

  final Widget child;

  @override
  ResumeLockState createState() => ResumeLockState();

  Widget buildLocker(BuildContext context);

  Route<dynamic> buildRoute(Widget child);

  static ResumeLockState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<ResumeLockState>();

  static ResumeLockState of(BuildContext context) => maybeOf(context)!;
}

class ResumeLockState extends State<ResumeLock> with WidgetsBindingObserver {
  late bool _locked;

  NavigatorState? get navigator => widget.navigatorKey.currentState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _locked = widget.locked;
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
        widget.delegate.onPaused();
      case AppLifecycleState.resumed:
        switch (await widget.delegate.onResumed(context)) {
          case ResumeLockActionNone():
            return;
          case ResumeLockActionLock():
            lock();
        }
      case _:
    }
  }

  Widget buildChild(Widget child) => PopScope(canPop: false, child: child);

  void lock() {
    if (_locked || navigator == null) {
      return;
    }
    _locked = true;
    unawaited(
      navigator!.push(
        widget.buildRoute(buildChild(widget.buildLocker(context))),
      ),
    );
    widget.delegate.onLocked();
  }

  void unlock() {
    if (!_locked || navigator == null) {
      return;
    }
    _locked = false;
    navigator!.pop();
    widget.delegate.onUnlocked();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
