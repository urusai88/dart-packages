import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pdfx/pdfx.dart';

import 'typedefs.dart';

PhotoViewController usePhotoViewController({
  Offset initialPosition = Offset.zero,
  double initialRotation = 0,
  double? initialScale,
  HookKeys keys,
}) =>
    use(
      _PageViewControllerHook(
        keys: keys,
        initialPosition: initialPosition,
        initialRotation: initialRotation,
        initialScale: initialScale,
      ),
    );

class _PageViewControllerHook extends Hook<PhotoViewController> {
  const _PageViewControllerHook({
    super.keys,
    required this.initialPosition,
    required this.initialRotation,
    this.initialScale,
  });

  final Offset initialPosition;
  final double initialRotation;
  final double? initialScale;

  @override
  _PageViewControllerHookState createState() => _PageViewControllerHookState();
}

class _PageViewControllerHookState
    extends HookState<PhotoViewController, _PageViewControllerHook> {
  late PhotoViewController _controller;

  @override
  void initHook() {
    super.initHook();
    _controller = PhotoViewController(
      initialPosition: hook.initialPosition,
      initialRotation: hook.initialRotation,
      initialScale: hook.initialScale,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  PhotoViewController build(BuildContext context) => _controller;

  @override
  String? get debugLabel => 'usePhotoViewController';
}
