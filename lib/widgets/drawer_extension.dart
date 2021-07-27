import 'package:Marbit/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class DrawerExtension extends StatelessWidget {
  final Color color;

  const DrawerExtension({
    Key key,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: kActiveNeumorphStyle.copyWith(
          color: color,
          boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.only(
              topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)))),
      child: const SizedBox(
        height: 90,
        width: 10,
      ),
    );
  }
}
