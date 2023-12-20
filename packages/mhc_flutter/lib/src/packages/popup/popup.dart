import 'package:flutter/widgets.dart' hide PopupRoute;

import 'popup_position_delegate.dart';
import 'popup_route.dart';

export 'popup_position_delegate.dart';
export 'popup_route.dart';

part 'popup_layout_delegate.dart';

RenderBox _getRenderBox(BuildContext context) =>
    context.findRenderObject()! as RenderBox;

final _doubleTween = Tween<double>(begin: 0, end: 1);

Widget fadeTransitionBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) =>
    FadeTransition(
      opacity: _doubleTween.animate(animation),
      child: child,
    );

///
/// [objectKey] является ключом объекта, по поторому позицианировать попап
Future<T?> showPopup<T>({
  required BuildContext context,
  required GlobalKey objectKey,
  RouteTransitionsBuilder transitionsBuilder = fadeTransitionBuilder,
  required PopupPositionDelegate positionDelegate,
  Color? barrierColor = const Color(0x00000000),
  String? barrierLabel,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
  required WidgetBuilder builder,
}) async {
  final overlay = Navigator.of(context).overlay;
  assert(
    () {
      if (overlay == null) {
        throw FlutterError('overlay is null');
      }
      if (objectKey.currentContext == null) {
        throw FlutterError('key.currentContext is null');
      }
      return true;
    }(),
    'Wrong config',
  );
  final keyBox = _getRenderBox(objectKey.currentContext!);
  final overlayBox = _getRenderBox(overlay!.context);
  final keySize = keyBox.size;
  final keyPosition = keyBox.localToGlobal(Offset.zero);
  final overlaySize = overlayBox.size;
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);

  final themes = InheritedTheme.capture(from: context, to: navigator.context);

  return navigator.push(
    PopupRoute<T>(
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      barrierDismissible: barrierDismissible,
      themes: themes,
      keySize: keySize,
      keyPosition: keyPosition,
      overlaySize: overlaySize,
      builder: builder,
      transitionBuilder: transitionsBuilder,
      positionDelegate: positionDelegate,
    ),
  );
}
