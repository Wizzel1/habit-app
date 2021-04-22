import 'package:Marbit/services/localStorage.dart';
import 'package:Marbit/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialController extends GetxController {
  List<TargetFocus> targets = [];
  ThemeData _themeData;
  AutoScrollController tutorialHabitDetailScrollController;
  Duration scrollDuration = const Duration(milliseconds: 500);
  bool hasFinishedHomeScreenStep = false;
  bool hasFinishedDetailScreenStep = false;
  bool hasFinishedCompletionStep = false;
  bool hasSeenWelcomeScreen = false;

  TutorialCoachMark tutorial;
  final double targetFocusRadius = 15;

  // -- HabitDetailScreen Keys --
  final GlobalKey scheduleRowKey = GlobalKey();
  final GlobalKey rewardListKey = GlobalKey();
  final GlobalKey editButtonKey = GlobalKey();
  final GlobalKey statisticsElementKey = GlobalKey();

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
    tutorialHabitDetailScrollController = AutoScrollController(
        viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, 12),
        axis: Axis.vertical,
        suggestedRowHeight: 400);

    loadTutorialInfo();
    super.onInit();
  }

  void loadTutorialInfo() async {
    hasFinishedHomeScreenStep = await LocalStorageService.loadTutorialProgress(
        "hasFinishedHomeScreenStep");
    hasFinishedDetailScreenStep =
        await LocalStorageService.loadTutorialProgress(
            "hasFinishedDetailScreenStep");
    hasFinishedCompletionStep = await LocalStorageService.loadTutorialProgress(
        "hasFinishedCompletionStep");
    hasSeenWelcomeScreen =
        await LocalStorageService.loadTutorialProgress("hasSeenWelcomeScreen");
  }

  void resumeToLatestTutorialStep(BuildContext context) {
    _getThemeData(context);
    if (!hasSeenWelcomeScreen) {
      _showWelcomeScreen(context);
      return;
    }

    if (!hasFinishedCompletionStep) {
      300
          .milliseconds
          .delay()
          .then((value) => _showCompletionTutorial(context));
      return;
    }
  }

  void _showWelcomeScreen(BuildContext context) async {
    if (hasSeenWelcomeScreen) return;

    bool wantToWatchTutorial = await Get.to(() => WelcomeScreen());

    hasSeenWelcomeScreen = true;
    LocalStorageService.saveTutorialProgress(
        "hasSeenWelcomeScreen", hasSeenWelcomeScreen);

    if (!wantToWatchTutorial) {
      hasFinishedDetailScreenStep = true;
      hasFinishedHomeScreenStep = true;
      hasFinishedCompletionStep = true;
      LocalStorageService.saveTutorialProgress(
          "hasFinishedHomeScreenStep", hasFinishedHomeScreenStep);
      LocalStorageService.saveTutorialProgress(
          "hasFinishedDetailScreenStep", hasFinishedDetailScreenStep);
      LocalStorageService.saveTutorialProgress(
          "hasFinishedCompletionStep", hasFinishedCompletionStep);
      update();
      return;
    }

    _showHomeScreenTutorial(context);
  }

  void _showHomeScreenTutorial(BuildContext context) {
    _addHomeScreenTargets();
    tutorial = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: kLightOrange,
      opacityShadow: 1.0,
      onFinish: () {
        print("finish");
        hasFinishedHomeScreenStep = true;
        LocalStorageService.saveTutorialProgress(
            "hasFinishedHomeScreenStep", hasFinishedHomeScreenStep);
      },
      onClickTarget: (target) {
        print(target);
      },
      onSkip: () {
        print("skip");
        hasFinishedHomeScreenStep = true;
        LocalStorageService.saveTutorialProgress(
            "hasFinishedHomeScreenStep", hasFinishedHomeScreenStep);
      },
    )..show();
  }

  void showHabitDetailTutorial(BuildContext context) {
    _addHabitDetailScreenTargets();
    tutorial = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: kLightOrange,
      opacityShadow: 1.0,
      onFinish: () {
        print("finish");
        hasFinishedDetailScreenStep = true;
        LocalStorageService.saveTutorialProgress(
            "hasFinishedDetailScreenStep", hasFinishedDetailScreenStep);
        update(["detailsTutorial"]);
      },
      onClickTarget: (target) {
        print(target);
      },
      onSkip: () {
        print("skip");
        hasFinishedDetailScreenStep = true;
        LocalStorageService.saveTutorialProgress(
            "hasFinishedDetailScreenStep", hasFinishedDetailScreenStep);
        update(["detailsTutorial"]);
      },
    )..show();
  }

  void _showCompletionTutorial(BuildContext context) {
    _addCompletionTutorialTargets();
    tutorial = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: kLightOrange,
      opacityShadow: 1.0,
      onFinish: () {
        print("finish");
        hasFinishedCompletionStep = true;
        LocalStorageService.saveTutorialProgress(
            "hasFinishedCompletionStep", hasFinishedCompletionStep);
      },
      onClickTarget: (target) {
        print(target);
      },
      onSkip: () {
        print("skip");
        hasFinishedCompletionStep = true;
        LocalStorageService.saveTutorialProgress(
            "hasFinishedCompletionStep", hasFinishedCompletionStep);
      },
    )..show();
  }

  void _nextTutorialStep() {
    tutorial.next();
  }

  void _previousTutorialStep() {
    tutorial.previous();
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
                    ),
                    ButtonRow(
                      onNextTapped: _nextTutorialStep,
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
                    ),
                    ButtonRow(
                      onNextTapped: _nextTutorialStep,
                      onPreviousTapped: _previousTutorialStep,
                    ),
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
                    ),
                    ButtonRow(
                      onNextTapped: _nextTutorialStep,
                      onPreviousTapped: _previousTutorialStep,
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  void _addHabitDetailScreenTargets() {
    targets.clear();
    targets.add(
      TargetFocus(
        enableTargetTab: false,
        enableOverlayTab: false,
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
                    style: _themeData.textTheme.headline4,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      'detailScreenTutorial_scheduleRowKey_message'.tr,
                      style: _themeData.textTheme.caption,
                    ),
                  ),
                  ButtonRow(
                    onNextTapped: () {
                      tutorialHabitDetailScrollController.scrollToIndex(1,
                          duration: scrollDuration,
                          preferPosition: AutoScrollPosition.end);
                      _nextTutorialStep();
                    },
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
        enableTargetTab: false,
        enableOverlayTab: false,
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
                      child: Column(
                        children: [
                          Text(
                            'detailScreenTutorial_rewardList_message',
                            style: _themeData.textTheme.caption,
                          ),
                          Row(
                            //TODO translate
                            children: [
                              Icon(FontAwesomeIcons.redoAlt,
                                  color: kBackGroundWhite),
                              Text(
                                '= Wiederkehrende Belohnungen',
                                style: _themeData.textTheme.caption,
                              ),
                            ],
                          ),
                          Row(
                            //TODO translate
                            children: [
                              Icon(FontAwesomeIcons.ban,
                                  color: kBackGroundWhite),
                              Text(
                                '= Einmalige Belohnungen',
                                style: _themeData.textTheme.caption,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    ButtonRow(
                      onPreviousTapped: () {
                        _previousTutorialStep();
                      },
                      onNextTapped: () {
                        tutorialHabitDetailScrollController.scrollToIndex(2,
                            duration: scrollDuration,
                            preferPosition: AutoScrollPosition.end);
                        _nextTutorialStep();
                      },
                    )
                  ],
                ),
              ))
        ],
      ),
    );
    targets.add(
      TargetFocus(
        enableTargetTab: false,
        enableOverlayTab: false,
        identify: "detail_statisticsElementKey",
        shape: ShapeLightFocus.RRect,
        radius: targetFocusRadius,
        keyTarget: statisticsElementKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //TODO translate
                  Text(
                    'Statistiken',
                    style: _themeData.textTheme.headline4,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    //TODO translate
                    child: Text(
                      'Hier siehst du auf einen Blick, wie oft du diese Gewohnheit in letzter Zeit abgeschlossen hast.',
                      style: _themeData.textTheme.caption,
                    ),
                  ),
                  ButtonRow(
                    onPreviousTapped: () {
                      tutorialHabitDetailScrollController.scrollToIndex(1,
                          duration: scrollDuration,
                          preferPosition: AutoScrollPosition.end);
                      _previousTutorialStep();
                    },
                    onNextTapped: () {
                      tutorialHabitDetailScrollController.scrollToIndex(3,
                          duration: scrollDuration,
                          preferPosition: AutoScrollPosition.end);
                      _nextTutorialStep();
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
    targets.add(
      TargetFocus(
        enableTargetTab: false,
        enableOverlayTab: false,
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
                  ButtonRow(
                    onNextTapped: _nextTutorialStep,
                    onPreviousTapped: () {
                      tutorialHabitDetailScrollController.scrollToIndex(2,
                          duration: scrollDuration,
                          preferPosition: AutoScrollPosition.end);
                      _previousTutorialStep();
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _addCompletionTutorialTargets() {
    targets.clear();
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
                    ),
                    ButtonRow(onNextTapped: _nextTutorialStep)
                  ],
                ),
              ))
        ],
      ),
    );
    targets.add(TargetFocus(
      identify: "completion_completeButton",
      shape: ShapeLightFocus.RRect,
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
                //TODO translate
                Text(
                  'Abschließen',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  //TODO translate
                  child: Text(
                    'Schließ jetzt das Tagesziel ab, um eine Belohnung zu erhalten!',
                    style: _themeData.textTheme.caption,
                  ),
                ),
                ButtonRow(onNextTapped: _nextTutorialStep)
              ],
            ),
          ),
        ),
      ],
    ));
  }
}

class ButtonRow extends StatelessWidget {
  final Function onPreviousTapped;
  final Function onNextTapped;

  const ButtonRow({Key key, this.onPreviousTapped, this.onNextTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            onPreviousTapped != null
                ? PreviousButton(
                    onPressed: onPreviousTapped,
                  )
                : const SizedBox.shrink(),
            const SizedBox(width: 50),
            onNextTapped != null
                ? NextButton(
                    onPressed: onNextTapped,
                  )
                : const SizedBox.shrink(),
          ],
        ),
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

class PreviousButton extends StatelessWidget {
  final Function onPressed;

  const PreviousButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      color: kBackGroundWhite,
      height: 50,
      minWidth: 50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      onPressed: onPressed,
      child: Icon(
        FontAwesomeIcons.arrowLeft,
        color: kDeepOrange,
        size: 20,
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
