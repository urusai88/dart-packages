import '../resume_lock_delegate.dart';

abstract class TimeResumeLockDelegate extends ResumeLockDelegate {
  TimeResumeLockDelegate({required this.lockTimeout});

  final Duration lockTimeout;

  DateTime? _pauseTime;

  bool shouldLock() {
    if (_pauseTime == null) {
      return false;
    }
    final shouldLockAt = _pauseTime!.add(lockTimeout);
    final should = DateTime.now().isAfter(shouldLockAt);
    if (should) {
      return true;
    }
    _pauseTime = null;
    return false;
  }

  @override
  void onPaused() => _pauseTime = DateTime.now();

  @override
  void onUnlocked() => _pauseTime = null;
}
