import 'shipper_entry_status.dart';
import 'shipper_load.dart';

abstract class ShipperEntryBase<EXTRA, R,
    ENTRY extends ShipperEntryBase<EXTRA, R, ENTRY>> {
  const ShipperEntryBase({
    required this.id,
    required this.load,
    required this.status,
  });

  final int id;

  final ShipperLoad<EXTRA> load;

  final ShipperEntryStatus<R> status;

  bool get isCompleted => status is ShipperEntryStatusCompleted;

  bool get isProcessing => status is ShipperEntryStatusProcessing;

  bool get isInQueue => status is ShipperEntryStatusInQueue;

  bool get isFailure => status is ShipperEntryStatusFailure;

  ENTRY withStatus(ShipperEntryStatus<R> status);

  ENTRY withLoad(ShipperLoad<EXTRA> load);

  ENTRY withExtra(EXTRA extra);

  Future<void> completed() async {}

  Future<void> cancelled() async {}
}
