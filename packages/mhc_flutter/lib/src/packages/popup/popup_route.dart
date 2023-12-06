import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter/widgets.dart' hide PopupRoute;

import 'popup.dart';

class PopupRoute<T> extends widgets.PopupRoute<T> {
  PopupRoute({
    required this.keySize,
    required this.keyPosition,
    required this.overlaySize,
    required this.builder,
    required this.transitionBuilder,
    required this.positionDelegate,
    this.themes,
    this.barrierColor,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.transitionDuration = const Duration(milliseconds: 200),
    Duration? reverseTransitionDuration,
  }) : _reverseTransitionDuration = reverseTransitionDuration;

  final Size keySize;
  final Offset keyPosition;
  final Size overlaySize;
  final WidgetBuilder builder;
  final RouteTransitionsBuilder transitionBuilder;
  final PopupPositionDelegate positionDelegate;
  final CapturedThemes? themes;

  @override
  final Color? barrierColor;

  @override
  final bool barrierDismissible;

  @override
  final String? barrierLabel;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      CustomSingleChildLayout(
        delegate: PopupLayoutDelegate(
          keySize: keySize,
          keyPosition: keyPosition,
          overlaySize: overlaySize,
          delegate: positionDelegate,
        ),
        child: transitionBuilder(
          context,
          animation,
          secondaryAnimation,
          themes?.wrap(builder(context)) ?? builder(context),
        ),
      );

  @override
  final Duration transitionDuration;

  final Duration? _reverseTransitionDuration;

  @override
  Duration get reverseTransitionDuration =>
      _reverseTransitionDuration ?? super.reverseTransitionDuration;
}
