import 'package:Marbit/util/util.dart';
import 'package:flutter/material.dart';

class DrawerExtension extends StatelessWidget {
  const DrawerExtension({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: kLightOrange,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))),
      height: 90,
      width: 15,
    );
  }
}
