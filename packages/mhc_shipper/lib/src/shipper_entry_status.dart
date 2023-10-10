sealed class ShipperEntryStatus<R> {
  const ShipperEntryStatus._();

  const factory ShipperEntryStatus.inQueue() = ShipperEntryStatusInQueue._;

  const factory ShipperEntryStatus.processing({
    required int progress,
    required int total,
  }) = ShipperEntryStatusProcessing._;

  const factory ShipperEntryStatus.processingZero() =
      ShipperEntryStatusProcessing._zero;

  const factory ShipperEntryStatus.failure(
    dynamic innerException,
    StackTrace innerStackTrace,
  ) = ShipperEntryStatusFailure._;

  const factory ShipperEntryStatus.completed(R result) =
      ShipperEntryStatusCompleted._;
}

class ShipperEntryStatusInQueue<R> extends ShipperEntryStatus<R> {
  const ShipperEntryStatusInQueue._() : super._();
}

class ShipperEntryStatusProcessing<R> extends ShipperEntryStatus<R> {
  const ShipperEntryStatusProcessing._({
    required this.progress,
    required this.total,
  }) : super._();

  const ShipperEntryStatusProcessing._zero() : this._(progress: 0, total: 0);

  final int progress;
  final int total;

  bool get isZero => progress == 0 && total == 0;

  ShipperEntryStatusProcessing copyWith({
    int? progress,
    int? total,
  }) {
    return ShipperEntryStatusProcessing._(
      progress: progress ?? this.progress,
      total: total ?? this.total,
    );
  }
}

class ShipperEntryStatusFailure<R> extends ShipperEntryStatus<R> {
  const ShipperEntryStatusFailure._(this.innerException, this.innerStackTrace)
      : super._();

  final dynamic innerException;
  final StackTrace innerStackTrace;
}

class ShipperEntryStatusCompleted<R> extends ShipperEntryStatus<R> {
  const ShipperEntryStatusCompleted._(this.result) : super._();

  final R result;

  ShipperEntryStatusCompleted<R> copyWith([R? result]) {
    return ShipperEntryStatusCompleted<R>._(result ?? this.result);
  }
}
