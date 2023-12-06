import 'shipper_entry_status.dart';
import 'shipper_load.dart';

abstract class ShipperEntryBase<ExtraT, ResultT,
    EntryT extends ShipperEntryBase<ExtraT, ResultT, EntryT>> {
  const ShipperEntryBase({
    required this.id,
    required this.load,
    required this.status,
  });

  final int id;

  final ShipperLoad<ExtraT> load;

  final ShipperEntryStatus<ResultT> status;

  bool get isCompleted => status is ShipperEntryStatusCompleted;

  bool get isProcessing => status is ShipperEntryStatusProcessing;

  bool get isInQueue => status is ShipperEntryStatusInQueue;

  bool get isFailure => status is ShipperEntryStatusFailure;

  EntryT withStatus(ShipperEntryStatus<ResultT> status);

  EntryT withLoad(ShipperLoad<ExtraT> load);

  EntryT withExtra(ExtraT extra);
}
