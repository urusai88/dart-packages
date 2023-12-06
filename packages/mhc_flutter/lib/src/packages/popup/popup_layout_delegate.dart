part of 'popup.dart';

class PopupLayoutDelegate extends SingleChildLayoutDelegate {
  const PopupLayoutDelegate({
    required this.keySize,
    required this.keyPosition,
    required this.overlaySize,
    required this.delegate,
  });

  final Size keySize;
  final Offset keyPosition;
  final Size overlaySize;
  final PopupPositionDelegate delegate;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      const BoxConstraints();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final overlayRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final keyRect = Rect.fromLTWH(
      keyPosition.dx,
      keyPosition.dy,
      keySize.width,
      keySize.height,
    );
    final insetsRect = delegate.resolveInsets(overlayRect);
    return delegate.resolvePosition(keyRect, insetsRect, childSize);
  }

  @override
  bool shouldRelayout(covariant PopupLayoutDelegate oldDelegate) =>
      keySize != oldDelegate.keySize ||
      keyPosition != oldDelegate.keyPosition ||
      overlaySize != oldDelegate.overlaySize ||
      delegate != oldDelegate.delegate;
}
