import 'package:Marbit/util/constants.dart';
import 'package:flutter/material.dart';

class BouncingButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color color;
  final double height;
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
  }) : super(key: key);

  @override
  _BouncingButtonState createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton>
    with SingleTickerProviderStateMixin {
  Animation<double> _scale;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.9)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(widget.borderRadius)),
          child: Center(
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
