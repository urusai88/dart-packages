import 'package:flutter/widgets.dart';

import 'resume_lock_action.dart';

abstract class ResumeLockDelegate {
  const ResumeLockDelegate();

  Future<ResumeLockAction> onResumed(BuildContext context);

  void onPaused() {}

  void onLocked() {}

  void onUnlocked() {}

  @protected
  ResumeLockAction doNone() => const ResumeLockAction.none();

  @protected
  ResumeLockAction doLock() => const ResumeLockAction.lock();
}
