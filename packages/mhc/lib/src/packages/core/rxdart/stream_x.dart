import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:rxdart/rxdart.dart';

typedef Listener<E> = void Function(E event);
typedef Where<E> = bool Function(E event);
typedef CompositionMaker<E> = Iterable<StreamSubscription<dynamic>> Function(
  Stream<E> stream,
);

extension StreamX<T> on Stream<T> {
  StreamSubscription<E> on<E>(Listener<E> listener, {Where<E>? where}) {
    var stream = whereType<E>();
    if (where != null) {
      stream = stream.where(where);
    }
    return stream.listen(listener);
  }

  CompositeSubscription makeCompositeSubscription(
    Ref ref,
    CompositionMaker<T> compositionMaker,
  ) {
    final composition = CompositeSubscription();
    compositionMaker(this).forEach(composition.add);
    ref.onDispose(composition.dispose);
    return composition;
  }
}
