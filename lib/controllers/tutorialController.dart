import 'package:Marbit/services/localStorage.dart';
import 'package:Marbit/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialController extends GetxController {
  List<TargetFocus> targets = [];
  ThemeData _themeData;

  bool hasFinishedHomeScreenTutorial = false;
  bool hasFinishedDetailTutorial = false;
  bool hasSeenWelcomeScreen = false;

  TutorialCoachMark tutorial;
  final double targetFocusRadius = 15;

  // -- HabitDetailScreen Keys --
  final GlobalKey scheduleRowKey = GlobalKey();
  final GlobalKey rewardListKey = GlobalKey();
  final GlobalKey editButtonKey = GlobalKey();

  // -- HomeScreen Keys --
  final GlobalKey homeTutorialHabitContainerKey = GlobalKey();
  final GlobalKey completionRowKey = GlobalKey();
  final GlobalKey completeButtonKey = GlobalKey();
  final GlobalKey drawerExtensionKey = GlobalKey();

  void _getThemeData(BuildContext context) {
    _themeData = Theme.of(context);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    loadTutorialInfo();
    super.onInit();
  }

  void loadTutorialInfo() async {
    hasFinishedHomeScreenTutorial =
        await LocalStorageService.loadTutorialProgressFromLocalStorage(
            "hasFinishedHomeScreenTutorial");
    hasFinishedDetailTutorial =
        await LocalStorageService.loadTutorialProgressFromLocalStorage(
            "hasFinishedDetailTutorial");
    hasSeenWelcomeScreen =
        await LocalStorageService.loadTutorialProgressFromLocalStorage(
            "hasSeenWelcomeScreen");
  }

  void showWelcomeScreen(BuildContext context) async {
    if (hasSeenWelcomeScreen) return;

    bool wantToWatchTutorial = await Get.to(() => WelcomeScreen());

    hasSeenWelcomeScreen = true;

    if (!wantToWatchTutorial) {
      hasFinishedDetailTutorial = true;
      hasFinishedHomeScreenTutorial = true;
      LocalStorageService.saveTutorialProgressToLocalStorage(
          "hasFinishedDetailTutorial", hasFinishedDetailTutorial);
      LocalStorageService.saveTutorialProgressToLocalStorage(
          "hasFinishedHomeScreenTutorial", hasFinishedHomeScreenTutorial);
      return;
    }
    LocalStorageService.saveTutorialProgressToLocalStorage(
        "hasSeenWelcomeScreen", hasSeenWelcomeScreen);

    showHomeScreenTutorial(context);
  }

  void showHomeScreenTutorial(BuildContext context) {
    _getThemeData(context);
    _addHomeScreenTargets();
    tutorial = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: kLightOrange,
      opacityShadow: 1.0,
      onFinish: () {
        print("finish");
        hasFinishedHomeScreenTutorial = true;
        LocalStorageService.saveTutorialProgressToLocalStorage(
            "hasFinishedHomeScreenTutorial", hasFinishedHomeScreenTutorial);
      },
      onClickTarget: (target) {
        print(target);
      },
      onSkip: () {
        print("skip");
        hasFinishedHomeScreenTutorial = true;
        LocalStorageService.saveTutorialProgressToLocalStorage(
            "hasFinishedHomeScreenTutorial", hasFinishedHomeScreenTutorial);
      },
    )..show();
  }

  void showHabitDetailTutorial(BuildContext context) {
    _getThemeData(context);
    _addHabitDetailScreenTargets();
    tutorial = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: kLightOrange,
      opacityShadow: 1.0,
      onFinish: () {
        print("finish");
        hasFinishedDetailTutorial = true;
        LocalStorageService.saveTutorialProgressToLocalStorage(
            "hasFinishedDetailTutorial", hasFinishedDetailTutorial);
      },
      onClickTarget: (target) {
        print(target);
      },
      onSkip: () {
        print("skip");
        hasFinishedDetailTutorial = true;
        LocalStorageService.saveTutorialProgressToLocalStorage(
            "hasFinishedDetailTutorial", hasFinishedDetailTutorial);
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
                      style: _themeData.textTheme.headline4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'homeScreenTutorial_container_message'.tr,
                        style: _themeData.textTheme.caption,
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
                      style: _themeData.textTheme.headline4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'homeScreenTutorial_completionrow_message'.tr,
                        style: _themeData.textTheme.caption,
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
        keyTarget: completeButtonKey,
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
                      style: _themeData.textTheme.headline4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'homeScreenTutorial_completeButton_message'.tr,
                        style: _themeData.textTheme.caption,
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
        keyTarget: drawerExtensionKey,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'homeScreenTutorial_drawerExtension_heading'.tr,
                      style: _themeData.textTheme.headline4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'homeScreenTutorial_drawerExtension_message'.tr,
                        style: _themeData.textTheme.caption,
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
        identify: "detail_scheduleRowKey",
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
                      style: _themeData.textTheme.caption,
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
        identify: "detail_editButtonKey",
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
                      style: _themeData.textTheme.headline4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'detailScreenTutorial_editButton_message'.tr,
                        style: _themeData.textTheme.caption,
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
        identify: "detail_rewardListKey",
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
                      style: _themeData.textTheme.headline4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'detailScreenTutorial_rewardList_message',
                        style: _themeData.textTheme.caption,
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

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightOrange,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to Marbit",
                style: Theme.of(context).textTheme.headline4,
              ),
              Text("Do you want to watch an interactive introduction?",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                    color: kBackGroundWhite,
                    onPressed: () {
                      Get.back(result: true);
                    },
                    child: Text(
                      "Lets go",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: kDeepOrange),
                    ),
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                    color: kBackGroundWhite,
                    onPressed: () {
                      Get.back(result: false);
                    },
                    child: Text(
                      "I'll figure it out myself",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: kDeepOrange),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
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
