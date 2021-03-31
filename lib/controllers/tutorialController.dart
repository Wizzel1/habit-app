import 'package:Marbit/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:tutorial_coach_mark/src/target/target_position.dart';

class TutorialController extends GetxController {
  List<TargetFocus> targets = [];

  bool hasFinishedTodayListTutorial = false;
  bool hasFinishedDetailTutorial = false;

  // -- HabitDetailScreen Keys --
  final GlobalKey scheduleRowKey = GlobalKey();
  final GlobalKey rewardListKey = GlobalKey();
  final GlobalKey editButtonKey = GlobalKey();

  // -- HomeScreen Keys --
  final GlobalKey homeTutorialHabitContainerKey = GlobalKey();
  final GlobalKey test5 = GlobalKey();
  final GlobalKey test6 = GlobalKey();
  final GlobalKey test7 = GlobalKey();

  void showDetailScreenTutorial(BuildContext context) {
    _addDetailScreenTargets();
    _showTutorial(context);
  }

  void showHomeScreenTutorial(BuildContext context) {
    _addHomeScreenTargets();
    _showTutorial(context);
  }

  void _showTutorial(BuildContext context) {
    TutorialCoachMark tutorial = TutorialCoachMark(
      context,
      targets: targets, // List<TargetFocus>
      colorShadow: kLightOrange, // DEFAULT Colors.black
      opacityShadow: 0.8,
      // alignSkip: Alignment.bottomRight,
      // textSkip: "SKIP",
      // paddingFocus: 10,
      // focusAnimationDuration: Duration(milliseconds: 500),
      // pulseAnimationDuration: Duration(milliseconds: 500),
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

  //TODO: create dedicated tutorial homescreen to replace the targetposition with a key
  void _addHomeScreenTargets() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "Target 1",
        shape: ShapeLightFocus.RRect,
        enableOverlayTab: true,
        radius: 15,
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
                      "Titulo lorem ipsum",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
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

  void _addDetailScreenTargets() {
    targets.clear();

    targets.add(
      TargetFocus(
        identify: "Target 2",
        shape: ShapeLightFocus.RRect,
        radius: 15,
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
                      "Schedule",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "This Row shows you, which days this Habit is scheduled for.",
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
        radius: 15,
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
                      "Rewards",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "These are the selected Rewards for this habit. You can Edit them by clicking on 'Edit' ",
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
        radius: 15,
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
                      "Rewards",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "These are the selected Rewards for this habit. You can Edit them by clicking on 'Edit' ",
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
}
