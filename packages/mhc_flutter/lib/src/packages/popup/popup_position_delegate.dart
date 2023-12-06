import 'package:flutter/rendering.dart';

import '../../../mhc_flutter.dart';

abstract class PopupPositionDelegate {
  const PopupPositionDelegate.withoutInsets()
      : minimumInsetsOffset = null,
        minimumInsetsWidthFactor = null,
        minimumInsetsHeightFactor = null;

  const PopupPositionDelegate.insetsOffset({
    required this.minimumInsetsOffset,
  })  : minimumInsetsWidthFactor = null,
        minimumInsetsHeightFactor = null;

  const PopupPositionDelegate.insetsAlignment({
    required this.minimumInsetsWidthFactor,
    required this.minimumInsetsHeightFactor,
  }) : minimumInsetsOffset = null;

  final Offset? minimumInsetsOffset;
  final double? minimumInsetsWidthFactor;
  final double? minimumInsetsHeightFactor;

  Rect resolveInsets(Rect base) {
    if (minimumInsetsOffset != null) {
      return Rect.fromLTRB(
        minimumInsetsOffset!.dx,
        minimumInsetsOffset!.dy,
        base.right - minimumInsetsOffset!.dx,
        base.bottom - minimumInsetsOffset!.dy,
      );
    }

    if (minimumInsetsWidthFactor != null && minimumInsetsHeightFactor != null) {
      return Rect.fromLTRB(
        base.width * minimumInsetsWidthFactor!,
        base.height * minimumInsetsHeightFactor!,
        base.right - base.width * minimumInsetsWidthFactor!,
        base.bottom - base.height * minimumInsetsHeightFactor!,
      );
    }

    return base;
  }

  Offset resolvePosition(Rect keyRect, Rect overlayRect, Size popupSize);
}

class PopupAlignPositionDelegate extends PopupPositionDelegate {
  const PopupAlignPositionDelegate.withoutInsets({
    required this.keyAlignment,
    required this.popupAlignment,
    this.reverseHorizontal = true,
    this.reverseVertical = true,
  }) : super.withoutInsets();

  const PopupAlignPositionDelegate.insetsAlignment({
    required this.keyAlignment,
    required this.popupAlignment,
    required super.minimumInsetsWidthFactor,
    required super.minimumInsetsHeightFactor,
    this.reverseHorizontal = true,
    this.reverseVertical = true,
  }) : super.insetsAlignment();

  const PopupAlignPositionDelegate.insetsOffset({
    required this.keyAlignment,
    required this.popupAlignment,
    required super.minimumInsetsOffset,
    this.reverseHorizontal = true,
    this.reverseVertical = true,
  }) : super.insetsOffset();

  final bool reverseHorizontal;
  final bool reverseVertical;
  final Alignment keyAlignment;
  final Alignment popupAlignment;

  Offset _computePosition(
    Alignment keyAlignment,
    Alignment popupAlignment,
    Rect keyRect,
    Size popupSize,
  ) =>
      keyAlignment.withinRect(keyRect) - popupAlignment.alongSize(popupSize);

  Offset _computeOverlaps(Offset pos, Rect popupBox, Rect overlayRect) {
    var dx = 0.0;
    var dy = 0.0;
    if (popupBox.left < overlayRect.left) {
      dx = popupBox.left - overlayRect.left;
    } else if (popupBox.right > overlayRect.right) {
      dx = popupBox.right - overlayRect.right;
    }
    if (popupBox.top < overlayRect.top) {
      dy = popupBox.top - overlayRect.top;
    } else if (popupBox.bottom > overlayRect.bottom) {
      dy = popupBox.bottom - overlayRect.bottom;
    }
    return Offset(dx, dy);
  }

  Offset _shiftToContains(Offset pos, Offset overlaps) =>
      pos - Offset(overlaps.dx, overlaps.dy);

  /// Создаёт Rect из Offset pos и Size size
  Rect _box(Offset pos, Size size) =>
      Rect.fromLTWH(pos.dx, pos.dy, size.width, size.height);

  Offset _copy({
    required Offset src,
    required Offset dst,
    bool saveX = false,
    bool saveY = false,
  }) =>
      Offset(saveX ? src.dx : dst.dx, saveY ? src.dy : dst.dy);

  @override
  Offset resolvePosition(Rect keyRect, Rect overlayRect, Size popupSize) {
    final posOriginal =
        _computePosition(keyAlignment, popupAlignment, keyRect, popupSize);

    var posResult = posOriginal;

    var popupBox = _box(posResult, popupSize);
    var overlaps = _computeOverlaps(posResult, popupBox, overlayRect);
    if (overlaps.dx > 0) {
      if (reverseHorizontal) {
        final pos = _copy(
          src: posResult,
          dst: _computePosition(
            keyAlignment.reverseX,
            popupAlignment.reverseX,
            keyRect,
            popupSize,
          ),
          saveY: true,
        );
        popupBox = _box(pos, popupSize);
        final overlaps = _computeOverlaps(pos, popupBox, overlayRect);
        if (overlaps.dx != 0) {
          posResult = _shiftToContains(pos, overlaps);
        } else {
          posResult = pos;
        }
      } else {
        posResult = _shiftToContains(posOriginal, overlaps);
      }
    }

    popupBox = _box(posResult, popupSize);
    overlaps = _computeOverlaps(posResult, popupBox, overlayRect);
    if (overlaps.dy > 0) {
      if (reverseVertical) {
        final pos = _copy(
          src: posResult,
          dst: _computePosition(
            keyAlignment.reverseY,
            popupAlignment.reverseY,
            keyRect,
            popupSize,
          ),
          saveX: true,
        );
        popupBox = _box(pos, popupSize);
        final overlaps = _computeOverlaps(pos, popupBox, overlayRect);
        if (overlaps.dy != 0) {
          posResult = _shiftToContains(posResult, overlaps);
        } else {
          posResult = pos;
        }
      } else {
        posResult = _shiftToContains(posResult, overlaps);
      }
    }

    return posResult;
  }
}
