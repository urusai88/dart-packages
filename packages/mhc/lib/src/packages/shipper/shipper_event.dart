import 'shipper_entry.dart';

sealed class ShipperEvent<EXTRA, R,
    ENTRY extends ShipperEntryBase<EXTRA, R, ENTRY>> {
  const ShipperEvent._();

  const factory ShipperEvent.completed({
    required ENTRY entry,
    required R result,
  }) = ShipperEventCompleted._;

  const factory ShipperEvent.failure({required ENTRY entry}) =
      ShipperEventFailure._;
}

class ShipperEventCompleted<EXTRA, R,
        ENTRY extends ShipperEntryBase<EXTRA, R, ENTRY>>
    extends ShipperEvent<EXTRA, R, ENTRY> {
  const ShipperEventCompleted._({required this.entry, required this.result})
      : super._();

  final ENTRY entry;
  final R result;
}

class ShipperEventFailure<EXTRA, R,
        ENTRY extends ShipperEntryBase<EXTRA, R, ENTRY>>
    extends ShipperEvent<EXTRA, R, ENTRY> {
  const ShipperEventFailure._({required this.entry}) : super._();

  final ENTRY entry;
}
