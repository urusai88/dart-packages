// ignore_for_file: omit_local_variable_types

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class FractionallyOverflowBox extends SingleChildRenderObjectWidget {
  const FractionallyOverflowBox({
    super.key,
    this.alignment = Alignment.center,
    this.clip = Clip.none,
    this.widthFactor,
    this.heightFactor,
    this.keepLayout = false,
    this.keepPaint = true,
    this.constraintChild = false,
    required Widget child,
  })  : assert(widthFactor == null || (widthFactor >= 0.0)),
        assert(heightFactor == null || (heightFactor >= 0.0)),
        super(child: child);

  final double? widthFactor;
  final double? heightFactor;
  final AlignmentGeometry alignment;
  final Clip clip;
  final bool keepLayout;
  final bool keepPaint;
  final bool constraintChild;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderFractionallyOverflowBox(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      alignment: alignment,
      clip: clip,
      constraintChild: constraintChild,
      textDirection: Directionality.maybeOf(context),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderFractionallyOverflowBox renderObject,
  ) {
    renderObject
      ..widthFactor = widthFactor
      ..heightFactor = heightFactor
      ..alignment = alignment
      ..clip = clip
      ..constraintChild = constraintChild
      ..textDirection = Directionality.maybeOf(context);
  }
}

class RenderFractionallyOverflowBox extends RenderAligningShiftedBox {
  RenderFractionallyOverflowBox({
    double? widthFactor,
    double? heightFactor,
    required super.alignment,
    required super.textDirection,
    required Clip clip,
    required bool constraintChild,
    super.child,
  })  : _widthFactor = widthFactor,
        _heightFactor = heightFactor,
        _clip = clip,
        _constraintChild = constraintChild;

  double? get widthFactor => _widthFactor;
  double? _widthFactor;

  set widthFactor(double? value) {
    if (_widthFactor != value) {
      _widthFactor = value;
      markNeedsLayout();
    }
  }

  double? get heightFactor => _heightFactor;
  double? _heightFactor;

  set heightFactor(double? value) {
    if (_heightFactor != value) {
      _heightFactor = value;
      markNeedsLayout();
    }
  }

  Clip get clip => _clip;
  Clip _clip;

  set clip(Clip value) {
    if (_clip != value) {
      _clip = value;
      markNeedsLayout();
    }
  }

  bool get constraintChild => _constraintChild;
  bool _constraintChild;

  set constraintChild(bool value) {
    if (_constraintChild != value) {
      _constraintChild = value;
      markNeedsLayout();
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final bool shrinkWrapWidth =
        _widthFactor != null || constraints.maxWidth == double.infinity;
    final bool shrinkWrapHeight =
        _heightFactor != null || constraints.maxHeight == double.infinity;
    if (child != null) {
      Size childSize = child!.getDryLayout(constraints.loosen());
      if (constraintChild) {
        childSize = Size(
          shrinkWrapWidth
              ? childSize.width * (_widthFactor ?? 1.0)
              : double.infinity,
          shrinkWrapHeight
              ? childSize.height * (_heightFactor ?? 1.0)
              : double.infinity,
        );
        childSize = child!.getDryLayout(
          constraints
              .copyWith(maxWidth: childSize.width, maxHeight: childSize.height)
              .loosen(),
        );
      }
      return constraints.constrain(childSize);
    }
    return constraints.constrain(
      Size(
        shrinkWrapWidth ? 0.0 : double.infinity,
        shrinkWrapHeight ? 0.0 : double.infinity,
      ),
    );
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final bool shrinkWrapWidth =
        _widthFactor != null || constraints.maxWidth == double.infinity;
    final bool shrinkWrapHeight =
        _heightFactor != null || constraints.maxHeight == double.infinity;

    if (child != null) {
      child!.layout(constraints.loosen(), parentUsesSize: true);
      Size childSize = child!.size;
      if (constraintChild) {
        childSize = Size(
          shrinkWrapWidth
              ? childSize.width * (_widthFactor ?? 1.0)
              : double.infinity,
          shrinkWrapHeight
              ? childSize.height * (_heightFactor ?? 1.0)
              : double.infinity,
        );
        child!.layout(
          constraints
              .copyWith(maxWidth: childSize.width, maxHeight: childSize.height)
              .loosen(),
          parentUsesSize: true,
        );
        childSize = child!.size;
      }
      size = constraints.constrain(childSize);
      alignChild();
    } else {
      size = constraints.constrain(
        Size(
          shrinkWrapWidth ? 0.0 : double.infinity,
          shrinkWrapHeight ? 0.0 : double.infinity,
        ),
      );
    }
  }
}
