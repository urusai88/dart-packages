import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef CallFunction = dynamic Function();

void useCall(CallFunction function, [List<Object?>? keys]) =>
    _CallHook(keys: keys, function: function);

class _CallHook extends Hook<void> {
  const _CallHook({
    super.keys,
    required this.function,
  });

  final CallFunction function;

  @override
  _CallHookState createState() => _CallHookState();
}

class _CallHookState extends HookState<void, _CallHook> {
  @override
  void initHook() {
    super.initHook();
    hook.function.call();
  }

  @override
  void build(BuildContext context) {}

  @override
  String? get debugLabel => 'useCall';
}
