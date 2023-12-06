sealed class ResumeLockAction {
  const ResumeLockAction._();

  const factory ResumeLockAction.none() = ResumeLockActionNone._;

  const factory ResumeLockAction.lock() = ResumeLockActionLock._;
}

class ResumeLockActionNone extends ResumeLockAction {
  const ResumeLockActionNone._() : super._();
}

class ResumeLockActionLock extends ResumeLockAction {
  const ResumeLockActionLock._() : super._();
}
