import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:state_notifier/state_notifier.dart';

import 'order_state.dart';

export 'order_state.dart';

enum OrderDirection { asc, desc }

const orderAsc = OrderDirection.asc;
const orderDesc = OrderDirection.desc;

typedef OrderComparators<P, E> = Map<OrderKey<P>, Comparator<E>>;

abstract class OrderNotifier<P, E> extends StateNotifier<OrderState<P>> {
  OrderNotifier([super.state = const OrderState()]);

  OrderNotifier.key(OrderKey<P> key) : this(OrderState.key(key));

  @protected
  final searchLength = 1;

  @protected
  final searchIgnoreCase = true;

  int compareDesc<T extends Comparable<T>>(T a, T b) => a.compareTo(b);

  int compareAsc<T extends Comparable<T>>(T a, T b) => b.compareTo(a);

  int compareStringsDesc(
    String a,
    String b, {
    bool ignoreCase = true,
    bool trim = true,
  }) {
    (a, b) =
        _prepareStringsForCompare(a, b, ignoreCase: ignoreCase, trim: trim);
    return compareDesc(a, b);
  }

  int compareStringsAsc(
    String a,
    String b, {
    bool ignoreCase = true,
    bool trim = true,
  }) {
    (a, b) =
        _prepareStringsForCompare(a, b, ignoreCase: ignoreCase, trim: trim);
    return compareAsc(a, b);
  }

  (String a, String b) _prepareStringsForCompare(
    String a,
    String b, {
    bool ignoreCase = true,
    bool trim = true,
  }) {
    if (ignoreCase) {
      a = a.toLowerCase();
      b = b.toLowerCase();
    }

    if (trim) {
      a = a.trim();
      b = b.trim();
    }

    return (a, b);
  }

  @protected
  bool searcher(E item, String query) => true;

  @protected
  OrderComparators<P, E> get comparators;

  void search(String? search) => update(search: search);

  void update({P? property, OrderDirection? direction, String? search}) {
    state = state.copyWith(
      property: property,
      direction: direction,
      search: searchIgnoreCase ? search?.toLowerCase() : search,
    );
  }

  void updateKey(OrderKey<P> key) =>
      update(property: key.property, direction: key.direction);

  void updateDesc({P? property}) {
    state = state.copyWith(property: property, direction: orderDesc);
  }

  void updateAsc({P? property}) {
    state = state.copyWith(property: property, direction: orderAsc);
  }

  void updateNull({bool? property, bool? direction}) {
    state = state.copyWithNull(property: property, direction: direction);
  }

  Iterable<E> compute(
    OrderState<P> state,
    Iterable<E> items, {
    int? searchLength,
  }) {
    if (state.search.isNotEmpty &&
        state.search.length >= (searchLength ?? this.searchLength)) {
      items = items.where((item) => searcher(item, state.search));
    }

    if (state.property != null) {
      final key = OrderKey<P>(state.property!, state.direction);
      final comparator = comparators[key];
      if (comparator != null) {
        items = items.toList()..sort(comparator);
      }
    }

    return items;
  }
}

class OrderKey<P> extends Equatable {
  const OrderKey(this.property, [this.direction]);

  const OrderKey.asc(this.property) : direction = orderAsc;

  const OrderKey.desc(this.property) : direction = orderDesc;

  final P property;
  final OrderDirection? direction;

  @override
  List<Object?> get props => [property, direction];
}
