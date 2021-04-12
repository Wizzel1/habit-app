import 'package:Marbit/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialController extends GetxController {
  List<TargetFocus> targets = [];

  bool hasFinishedTodayListTutorial = false;
  bool hasFinishedDetailTutorial = false;
  TutorialCoachMark tutorial;
  final double targetFocusRadius = 15;
  // -- HabitDetailScreen Keys --
  final GlobalKey scheduleRowKey = GlobalKey();
  final GlobalKey rewardListKey = GlobalKey();
  final GlobalKey editButtonKey = GlobalKey();

  // -- HomeScreen Keys --
  final GlobalKey homeTutorialHabitContainerKey = GlobalKey();
  final GlobalKey completionRowKey = GlobalKey();
  final GlobalKey completeButton = GlobalKey();
  final GlobalKey test7 = GlobalKey();

  void showHomeScreenTutorial(BuildContext context) {
    _addHomeScreenTargets();
    tutorial = TutorialCoachMark(
      context,
      targets: targets, // List<TargetFocus>
      colorShadow: kLightOrange, // DEFAULT Colors.black
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print(target);
      },
      onSkip: () {
        print("skip");
      },
    )..show();
  }

  void showHabitDetailTutorial(BuildContext context) {
    _addHabitDetailScreenTargets();
    tutorial = TutorialCoachMark(
      context,
      targets: targets, // List<TargetFocus>
      colorShadow: kLightOrange, // DEFAULT Colors.black
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print(target);
      },
      onSkip: () {
        print("skip");
      },
    )..show();
    // tutorial.skip();
    // tutorial.finish();
    // tutorial.next(); // call next target programmatically
    // tutorial.previous(); // call previous target programmatically
  }

  void _addHomeScreenTargets() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "Target 1",
        shape: ShapeLightFocus.RRect,
        enableOverlayTab: true,
        radius: targetFocusRadius,
        keyTarget: homeTutorialHabitContainerKey,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'homeScreenTutorial_container_heading'.tr,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'homeScreenTutorial_container_message'.tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 2",
        shape: ShapeLightFocus.RRect,
        enableOverlayTab: true,
        radius: targetFocusRadius,
        keyTarget: completionRowKey,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'homeScreenTutorial_completionrow_heading'.tr,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'homeScreenTutorial_completionrow_message'.tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 3",
        shape: ShapeLightFocus.RRect,
        enableOverlayTab: true,
        radius: targetFocusRadius,
        keyTarget: completeButton,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'homeScreenTutorial_completeButton_heading'.tr,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'homeScreenTutorial_completeButton_message'.tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  void _nextTutorialStep() {
    tutorial.next();
  }

  void _previousTutorialStep() {
    tutorial.previous();
  }

  void _addHabitDetailScreenTargets() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "Target 2",
        shape: ShapeLightFocus.RRect,
        radius: targetFocusRadius,
        keyTarget: scheduleRowKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'detailScreenTutorial_scheduleRowKey_heading'.tr,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      'detailScreenTutorial_scheduleRowKey_message'.tr,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  NextButton(
                    onPressed: _nextTutorialStep,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 2",
        shape: ShapeLightFocus.RRect,
        radius: targetFocusRadius,
        keyTarget: editButtonKey,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'detailScreenTutorial_editButton_heading'.tr,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'detailScreenTutorial_editButton_message'.tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    NextButton(
                      onPressed: _nextTutorialStep,
                    )
                  ],
                ),
              ))
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 2",
        shape: ShapeLightFocus.RRect,
        radius: targetFocusRadius,
        keyTarget: rewardListKey,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'detailScreenTutorial_rewardList_heading'.tr,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'detailScreenTutorial_rewardList_message',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    NextButton(
                      onPressed: _nextTutorialStep,
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  final Function onPressed;

  const NextButton({
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      color: kDeepOrange,
      height: 50,
      minWidth: 50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      onPressed: onPressed,
      child: Icon(
        FontAwesomeIcons.arrowRight,
        color: kBackGroundWhite,
        size: 20,
      ),
    );
  }
}
