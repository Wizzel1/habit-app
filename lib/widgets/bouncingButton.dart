import 'package:Marbit/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'dart:ui';
import '../util/constants.dart';

class NeumorphPressSwitch extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color color;
  final double height;
  final double width;
  final double borderRadius;
  final bool inPressedState;

  const NeumorphPressSwitch({
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
  _NeumorphPressSwitchState createState() => _NeumorphPressSwitchState();
}

class _NeumorphPressSwitchState extends State<NeumorphPressSwitch>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (PointerDownEvent event) {
        if (widget.onPressed == null) return;
        widget.onPressed();
      },
      onPointerUp: (PointerUpEvent event) async {},
      child: Neumorphic(
        style: kInactiveNeumorphStyle.copyWith(
            color: widget.color,
            borderRadius: widget.borderRadius,
            depth: widget.inPressedState ? -2.0 : 2.0),
        child: Container(
          height: widget.height,
          width: widget.width,
          child: Center(
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class TestButton extends StatefulWidget {
  final Function onPressed;
  final Widget child;
  final double height;
  final double width;
  final double borderRadius;

  TestButton({
    Key key,
    this.onPressed,
    this.child,
    this.height = 40,
    this.width = 100,
    this.borderRadius = 8,
  }) : super(key: key);
  @override
  _TestButtonState createState() => _TestButtonState();
}

class _TestButtonState extends State<TestButton> {
  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      padding: EdgeInsets.zero,
      onPressed: widget.onPressed,
      minDistance: 0.0,
      style: kInactiveNeumorphStyle,
      child: Container(
        height: widget.height,
        width: widget.width,
        child: Center(
          child: widget.child,
        ),
      ),
    );
  }
}
