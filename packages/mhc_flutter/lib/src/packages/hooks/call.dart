import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'typedefs.dart';

typedef CallFunction = dynamic Function();

void useCall(CallFunction function, [HookKeys keys]) =>
    use(_CallHook(keys: keys, function: function, sync: true));

void useAsyncCall(CallFunction function, [HookKeys keys]) =>
    use(_CallHook(keys: keys, function: function, sync: false));

class _CallHook extends Hook<dynamic> {
  const _CallHook({super.keys, required this.function, required this.sync});

  final CallFunction function;
  final bool sync;

  @override
  _CallHookState createState() => _CallHookState();
}

class _CallHookState extends HookState<dynamic, _CallHook> {
  @override
  void initHook() {
    super.initHook();
    if (hook.sync) {
      hook.function.call();
    } else {
      Future(hook.function.call);
    }
  }

  @override
  dynamic build(BuildContext context) {}

  @override
  String? get debugLabel => 'useCall';
}
