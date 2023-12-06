import 'dart:async';

import 'package:logging/logging.dart';
import 'package:riverpod/riverpod.dart';

export 'package:logging/logging.dart';
export 'package:riverpod/riverpod.dart';

Logger makeEventsLogger(Ref ref, {String name = 'Events'}) => Logger(name);

StreamController<E> makeEventsBus<E>(Ref ref) {
  final sink = StreamController<E>.broadcast();
  ref.onDispose(sink.close);
  return sink;
}

Stream<E> makeEvents<E>(
  Ref ref, {
  required Stream<E> eventStream,
  required Logger eventLogger,
}) {
  final subscription = eventStream.listen(eventLogger.finest);
  ref.onDispose(subscription.cancel);
  return eventStream;
}
