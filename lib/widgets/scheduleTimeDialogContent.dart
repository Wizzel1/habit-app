import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/util/util.dart';
import 'package:Marbit/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class DialogContent extends StatelessWidget {
  final NotificationTimesController _notificationTimesController =
      Get.find<NotificationTimesController>();

  DialogContent({Key key, @required this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    child: Neumorphic(
                      style: kActiveNeumorphStyle.copyWith(
                          color: kBackGroundWhite),
                      child: TextField(
                        controller: _notificationTimesController.hourController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            counterText: "", border: InputBorder.none),
                        maxLength: 2,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Theme.of(context).accentColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Text(":",
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(color: kDeepOrange)),
                Expanded(
                  child: Container(
                    child: Neumorphic(
                      style: kActiveNeumorphStyle.copyWith(
                          color: kBackGroundWhite),
                      child: TextField(
                        controller:
                            _notificationTimesController.minuteController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            counterText: "", border: InputBorder.none),
                        maxLength: 2,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Theme.of(context).accentColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomNeumorphButton(
              onPressed: () {
                _notificationTimesController.saveSelectedTimeTo(index)
                    ? Get.back()
                    : null;
              },
              width: 56,
              height: 56,
              color: kSuccessGreen,
              child: Icon(
                FontAwesomeIcons.check,
                color: kBackGroundWhite,
              )),
        ],
      ),
    );
  }
}