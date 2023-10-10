import 'dart:async';

class ListenerLink {
  const ListenerLink(StreamSubscription<void> subscription)
      : _subscription = subscription;

  final StreamSubscription<void> _subscription;
}

mixin class Listenable {
  final _streamController = StreamController<void>.broadcast(sync: true);

  void dispose() => unawaited(_streamController.close());

  ListenerLink addListener(void Function() callback) =>
      ListenerLink(_streamController.stream.listen((_) => callback));

  Future<void> removeListener(ListenerLink listener) async =>
      listener._subscription.cancel();

  void notifyListeners() => _streamController.add(null);
}
