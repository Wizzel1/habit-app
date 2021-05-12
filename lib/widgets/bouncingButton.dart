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

class _NeumorphPressSwitchState extends State<NeumorphPressSwitch> {
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
            depth: widget.inPressedState ? -2.0 : 2.0,
            boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(widget.borderRadius))),
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

class CustomNeumorphButton extends StatefulWidget {
  final Function onPressed;
  final Widget child;
  final double height;
  final double width;
  final double borderRadius;
  final Color color;

  CustomNeumorphButton(
      {Key key,
      this.onPressed,
      this.child,
      this.height = 40,
      this.width = 100,
      this.borderRadius = 8,
      this.color = kBackGroundWhite})
      : super(key: key);
  @override
  _CustomNeumorphButtonState createState() => _CustomNeumorphButtonState();
}

class _CustomNeumorphButtonState extends State<CustomNeumorphButton> {
  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      duration: const Duration(milliseconds: 1),
      padding: EdgeInsets.zero,
      onPressed: widget.onPressed,
      style: kInactiveNeumorphStyle.copyWith(
          color: widget.color,
          boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.circular(widget.borderRadius))),
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
