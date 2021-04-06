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

  // -- HabitDetailScreen Keys --
  final GlobalKey scheduleRowKey = GlobalKey();
  final GlobalKey rewardListKey = GlobalKey();
  final GlobalKey editButtonKey = GlobalKey();

  // -- HomeScreen Keys --
  final GlobalKey homeTutorialHabitContainerKey = GlobalKey();
  final GlobalKey test5 = GlobalKey();
  final GlobalKey test6 = GlobalKey();
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
