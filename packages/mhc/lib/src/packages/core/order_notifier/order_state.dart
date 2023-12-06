import 'package:equatable/equatable.dart';

import 'order_notifier.dart';

class OrderState<P> extends Equatable {
  const OrderState({this.property, this.direction, this.search = ''});

  const OrderState.desc({this.property, this.search = ''})
      : direction = orderDesc;

  const OrderState.asc({this.property, this.search = ''})
      : direction = orderAsc;

  const OrderState.a2z({this.property, this.search = ''})
      : direction = orderDesc;

  const OrderState.z2a({this.property, this.search = ''})
      : direction = orderAsc;

  final P? property;
  final OrderDirection? direction;
  final String search;

  OrderState<P> copyWith({
    P? property,
    OrderDirection? direction,
    String? search,
  }) =>
      OrderState(
        property: property ?? this.property,
        direction: direction ?? this.direction,
        search: search ?? this.search,
      );

  OrderState<P> copyWithNull({
    bool? property,
    bool? direction,
  }) =>
      OrderState(
        property: (property ?? false) ? null : this.property,
        direction: (direction ?? false) ? null : this.direction,
        search: search,
      );

  @override
  List<Object?> get props => [property, direction, search];
}
