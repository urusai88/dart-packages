import '../resume_lock_delegate.dart';

abstract class TimeResumeLockDelegate extends ResumeLockDelegate {
  TimeResumeLockDelegate({required this.durationBeforeLock});

  final Duration durationBeforeLock;

  DateTime? _pauseTime;

  bool shouldLock() {
    if (_pauseTime == null) {
      return false;
    }
    final shouldLockAt = _pauseTime!.add(durationBeforeLock);
    final should = DateTime.now().isAfter(shouldLockAt);
    if (should) {
      return true;
    }
    _pauseTime = null;
    return false;
  }

  @override
  void pause() {
    _pauseTime = DateTime.now();
  }

  @override
  void unlocked() {
    _pauseTime = null;
  }
}
