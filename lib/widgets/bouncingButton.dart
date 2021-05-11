import 'dart:ui';

import 'package:Marbit/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../util/constants.dart';

class BouncingButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color color;
  final double height;
  final bool inPressedState;
  final double width;
  final double borderRadius;

  const BouncingButton({
    Key key,
    @required this.onPressed,
    @required this.child,
    this.color = kBackGroundWhite,
    this.height = 40,
    this.width = 100,
    this.borderRadius = 8,
    this.inPressedState = false,
  }) : super(key: key);

  @override
  _BouncingButtonState createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton>
    with SingleTickerProviderStateMixin {
  Animation<double> _scale;
  AnimationController _controller;
  Animation<Decoration> _decoration;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );
    _scale = Tween<double>(begin: 1.0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _decoration = DecorationTween(
      begin: BoxDecoration(
          boxShadow: [kBoxShadow],
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.borderRadius)),
      end: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.borderRadius)
          // No shadow.
          ),
    ).animate(_controller);
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (PointerDownEvent event) {
        _controller.forward();

        if (widget.onPressed == null) return;
        widget.onPressed();
      },
      onPointerUp: (PointerUpEvent event) async {
        await _controller.forward();
        await _controller.reverse();
      },
      child: ScaleTransition(
          scale: _scale,
          child: widget.inPressedState
              ? InnerShadow(
                  blur: 1,
                  color: kBoxShadowBlack,
                  offset: const Offset(1, 5),
                  child: Container(
                    height: widget.height,
                    width: widget.width,
                    decoration: BoxDecoration(
                        color: widget.color,
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius)),
                    child: Center(
                      child: widget.child,
                    ),
                  ),
                )
              : DecoratedBoxTransition(
                  decoration: _decoration,
                  child: Container(
                    height: widget.height,
                    width: widget.width,
                    child: Center(
                      child: widget.child,
                    ),
                  ),
                )),
    );
  }
}

class InnerShadow extends SingleChildRenderObjectWidget {
  const InnerShadow({
    Key key,
    this.blur = 10,
    this.color = Colors.black38,
    this.offset = const Offset(10, 10),
    Widget child,
  }) : super(key: key, child: child);

  final double blur;
  final Color color;
  final Offset offset;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final _RenderInnerShadow renderObject = _RenderInnerShadow();
    updateRenderObject(context, renderObject);
    return renderObject;
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderInnerShadow renderObject) {
    renderObject
      ..color = color
      ..blur = blur
      ..dx = offset.dx
      ..dy = offset.dy;
  }
}

class _RenderInnerShadow extends RenderProxyBox {
  double blur;
  Color color;
  double dx;
  double dy;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;

    final Rect rectOuter = offset & size;
    final Rect rectInner = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      size.width - dx,
      size.height,
    );
    final Canvas canvas = context.canvas..saveLayer(rectOuter, Paint());
    context.paintChild(child, offset);
    final Paint shadowPaint = Paint()
      ..blendMode = BlendMode.srcATop
      ..imageFilter = ImageFilter.blur(sigmaX: blur, sigmaY: blur)
      ..colorFilter = ColorFilter.mode(color, BlendMode.srcOut);

    canvas
      ..saveLayer(rectOuter, shadowPaint)
      ..saveLayer(rectInner, Paint())
      ..translate(dx, dy);
    context.paintChild(child, offset);
    context.canvas..restore()..restore()..restore();
  }
}
