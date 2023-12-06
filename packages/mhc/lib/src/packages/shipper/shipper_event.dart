import 'shipper_entry.dart';

sealed class ShipperEvent<ExtraT, ResultT,
    EntryT extends ShipperEntryBase<ExtraT, ResultT, EntryT>> {
  const ShipperEvent._();

  const factory ShipperEvent.completed({
    required EntryT entry,
    required ResultT result,
  }) = ShipperEventCompleted._;

  const factory ShipperEvent.failure({required EntryT entry}) =
      ShipperEventFailure._;
}

class ShipperEventCompleted<ExtraT, ResultT,
        EntryT extends ShipperEntryBase<ExtraT, ResultT, EntryT>>
    extends ShipperEvent<ExtraT, ResultT, EntryT> {
  const ShipperEventCompleted._({required this.entry, required this.result})
      : super._();

  final EntryT entry;
  final ResultT result;
}

class ShipperEventFailure<ExtraT, ResultT,
        EntryT extends ShipperEntryBase<ExtraT, ResultT, EntryT>>
    extends ShipperEvent<ExtraT, ResultT, EntryT> {
  const ShipperEventFailure._({required this.entry}) : super._();

  final EntryT entry;
}
