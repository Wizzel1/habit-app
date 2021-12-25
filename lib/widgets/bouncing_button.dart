
import 'package:Marbit/util/constants.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../util/constants.dart';

class NeumorphPressSwitch extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;
  final Widget child;
  final double height;
  final double width;
  final NeumorphicStyle? style;
  final double borderRadius;

  const NeumorphPressSwitch({
    Key? key,
    required this.onPressed,
    required this.child,
    this.height = 40,
    this.width = 100,
    this.style,
    this.borderRadius = 8,
    this.onLongPressed,
  }) : super(key: key);

  @override
  _NeumorphPressSwitchState createState() => _NeumorphPressSwitchState();
}

class _NeumorphPressSwitchState extends State<NeumorphPressSwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onPressed,
      onLongPress: widget.onLongPressed,
      child: Neumorphic(
        style: widget.style,
        child: SizedBox(
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
  final VoidCallback? onPressed;
  final Widget? child;
  final double height;
  final double width;
  final double borderRadius;
  final Color? color;
  final NeumorphicStyle style;

  const CustomNeumorphButton(
      {Key? key,
      this.onPressed,
      this.child,
      this.height = 40,
      this.width = 100,
      this.borderRadius = 8,
      this.color = kBackGroundWhite,
      this.style = kInactiveNeumorphStyle})
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
      style: widget.style.copyWith(
          color: widget.color,
          boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.circular(widget.borderRadius))),
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: Center(
          child: widget.child,
        ),
      ),
    );
  }
}
