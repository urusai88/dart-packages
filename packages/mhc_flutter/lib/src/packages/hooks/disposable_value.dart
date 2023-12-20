import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'typedefs.dart';

T useDisposableValue<T>({
  required ValueGetter<T> builder,
  required ValueSetter<T> dispose,
  HookKeys keys,
}) =>
    use(_DisposableValueHook(keys: keys, builder: builder, dispose: dispose));

class _DisposableValueHook<T> extends Hook<T> {
  const _DisposableValueHook({
    super.keys,
    required this.builder,
    required this.dispose,
  });

  final ValueGetter<T> builder;
  final ValueSetter<T> dispose;

  @override
  _DisposableValueHookState<T> createState() => _DisposableValueHookState<T>();
}

class _DisposableValueHookState<T>
    extends HookState<T, _DisposableValueHook<T>> {
  late T _value;

  @override
  T build(BuildContext context) => _value;

  @override
  void initHook() {
    super.initHook();
    _build();
  }

  @override
  void didUpdateHook(_DisposableValueHook<T> oldHook) {
    super.didUpdateHook(oldHook);
    if (hook.keys == null) {
      _dispose();
      _build();
    }
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _build() => _value = hook.builder();

  void _dispose() => hook.dispose(_value);

  @override
  String? get debugLabel => 'useDisposableValue';
}
