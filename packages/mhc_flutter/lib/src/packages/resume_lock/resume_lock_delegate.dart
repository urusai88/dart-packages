import 'package:flutter/widgets.dart';

import 'resume_lock_action.dart';

abstract class ResumeLockDelegate {
  const ResumeLockDelegate();

  Future<ResumeLockAction> action(BuildContext context);

  void pause();

  void unlocked();

  @protected
  ResumeLockAction doNone() => const ResumeLockAction.none();

  ResumeLockAction doLock() => const ResumeLockAction.lock();
}
