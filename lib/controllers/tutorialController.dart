import 'package:Marbit/services/localStorage.dart';
import 'package:Marbit/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:Marbit/widgets/widgets.dart';

class TutorialController extends GetxController {
  List<TargetFocus> targets = [];
  ThemeData _themeData;
  AutoScrollController tutorialHabitDetailScrollController;
  Duration scrollDuration = const Duration(milliseconds: 500);

  //true after the welcome screen has been closed
  bool hasSeenWelcomeScreen = false;
  //true after first tutorial ended/before user has to tap for details
  bool hasFinishedHomeScreenStep = false;
  //true after the detail tutorial ended / still in detailsscreen
  bool hasFinishedDetailScreenStep = false;
  //true after the completion tutorial/ before the user has to complete habit
  bool hasFinishedCompletionStep = false;
  //true after the drawer extension has been shown
  bool hasFinishedDrawerExtensionStep = false;

  static const int innerDrawerBuilderID = 1;
  static const int todaysHabitsBuilderID = 2;
  static const int habitDetailBuilderID = 3;

  TutorialCoachMark tutorial;
  final double targetFocusRadius = 15;
  final Duration _focusAnimationDuration = Duration(milliseconds: 400);

  // -- HabitDetailScreen Keys --
  final GlobalKey scheduleRowKey = GlobalKey();
  final GlobalKey rewardListKey = GlobalKey();
  final GlobalKey editButtonKey = GlobalKey();
  final GlobalKey statisticsElementKey = GlobalKey();

  // -- HomeScreen Step Keys --
  final GlobalKey homeTutorialHabitContainerKey = GlobalKey();
  final GlobalKey completionRowKey = GlobalKey();

  // -- Completion Step Keys --
  final GlobalKey completeButtonKey = GlobalKey();

  // -- Finished tutorial Step --
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
    super.onInit();
  }

  Future<void> loadTutorialInfo() async {
    hasFinishedHomeScreenStep = await LocalStorageService.loadTutorialProgress(
        "hasFinishedHomeScreenStep");
    hasFinishedDetailScreenStep =
        await LocalStorageService.loadTutorialProgress(
            "hasFinishedDetailScreenStep");
    hasFinishedCompletionStep = await LocalStorageService.loadTutorialProgress(
        "hasFinishedCompletionStep");
    hasSeenWelcomeScreen =
        await LocalStorageService.loadTutorialProgress("hasSeenWelcomeScreen");
    hasFinishedDrawerExtensionStep =
        await LocalStorageService.loadTutorialProgress(
            "hasFinishedDrawerExtensionStep");
  }

  void resumeToLatestTutorialStep(BuildContext context) {
    _getThemeData(context);

    if (!hasSeenWelcomeScreen) {
      _showWelcomeScreen(context);
      return;
    }

    if (!hasFinishedDetailScreenStep) {
      _showHabitDetailTutorial(context);
      return;
    }

    if (!hasFinishedCompletionStep) {
      300
          .milliseconds
          .delay()
          .then((value) => _showCompletionTutorial(context));
      return;
    }

    if (!hasFinishedDrawerExtensionStep) {
      300
          .milliseconds
          .delay()
          .then((value) => _showDrawerExtensionTutorial(context));
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
      hasFinishedDrawerExtensionStep = true;
      LocalStorageService.saveTutorialProgress(
          "hasFinishedHomeScreenStep", hasFinishedHomeScreenStep);
      LocalStorageService.saveTutorialProgress(
          "hasFinishedDetailScreenStep", hasFinishedDetailScreenStep);
      LocalStorageService.saveTutorialProgress(
          "hasFinishedCompletionStep", hasFinishedCompletionStep);
      LocalStorageService.saveTutorialProgress(
          "hasFinishedDrawerExtensionStep", hasFinishedDrawerExtensionStep);
      update([innerDrawerBuilderID, todaysHabitsBuilderID, true]);
      return;
    }

    _showHomeScreenTutorial(context);
  }

  void _showHomeScreenTutorial(BuildContext context) {
    _addHomeScreenTargets();
    tutorial = TutorialCoachMark(
      context,
      targets: targets,
      focusAnimationDuration: _focusAnimationDuration,
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

  void _showHabitDetailTutorial(BuildContext context) {
    _addHabitDetailScreenTargets();
    tutorial = TutorialCoachMark(
      context,
      targets: targets,
      focusAnimationDuration: _focusAnimationDuration,
      colorShadow: kLightOrange,
      opacityShadow: 1.0,
      onFinish: () {
        print("finish");
        hasFinishedDetailScreenStep = true;
        LocalStorageService.saveTutorialProgress(
            "hasFinishedDetailScreenStep", hasFinishedDetailScreenStep);
        update([habitDetailBuilderID, todaysHabitsBuilderID, true]);
      },
      onClickTarget: (target) {
        print(target);
      },
      onSkip: () {
        print("skip");
        hasFinishedDetailScreenStep = true;
        LocalStorageService.saveTutorialProgress(
            "hasFinishedDetailScreenStep", hasFinishedDetailScreenStep);
        update([habitDetailBuilderID, todaysHabitsBuilderID, true]);
      },
    )..show();
  }

  void _showCompletionTutorial(BuildContext context) {
    _addCompletionTutorialTargets();
    tutorial = TutorialCoachMark(
      context,
      targets: targets,
      focusAnimationDuration: _focusAnimationDuration,
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

  void _showDrawerExtensionTutorial(BuildContext context) {
    update([todaysHabitsBuilderID, true]);
    _addRewardPopupTutorialTargets();
    tutorial = TutorialCoachMark(
      context,
      targets: targets,
      focusAnimationDuration: _focusAnimationDuration,
      colorShadow: kLightOrange,
      opacityShadow: 1.0,
      onFinish: () {
        print("finish");
        hasFinishedDrawerExtensionStep = true;
        LocalStorageService.saveTutorialProgress(
            "hasFinishedDrawerExtensionStep", hasFinishedDrawerExtensionStep);
        update([innerDrawerBuilderID, todaysHabitsBuilderID, true]);
      },
      onClickTarget: (target) {
        print(target);
      },
      onSkip: () {
        print("skip");
        hasFinishedDrawerExtensionStep = true;
        LocalStorageService.saveTutorialProgress(
            "hasFinishedDrawerExtensionStep", hasFinishedDrawerExtensionStep);
        update([innerDrawerBuilderID, todaysHabitsBuilderID, true]);
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
        enableOverlayTab: false,
        enableTargetTab: false,
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
        identify: "Target 1",
        shape: ShapeLightFocus.RRect,
        enableOverlayTab: false,
        enableTargetTab: false,
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
                      //TODO translate
                      'Details',
                      style: _themeData.textTheme.headline4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Tippe jetzt auf die Gewohnheit, um Details anzuzeigen.',
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
  }

  void _addHabitDetailScreenTargets() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "detail_scheduleRowKey",
        shape: ShapeLightFocus.RRect,
        enableTargetTab: false,
        enableOverlayTab: false,
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
        identify: "detail_rewardListKey",
        shape: ShapeLightFocus.RRect,
        enableTargetTab: false,
        enableOverlayTab: false,
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
        identify: "detail_statisticsElementKey",
        shape: ShapeLightFocus.RRect,
        enableTargetTab: false,
        enableOverlayTab: false,
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
        identify: "detail_editButtonKey",
        shape: ShapeLightFocus.RRect,
        enableTargetTab: false,
        enableOverlayTab: false,
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
        identify: "Target 2",
        shape: ShapeLightFocus.RRect,
        enableOverlayTab: false,
        enableTargetTab: false,
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
                      'completionScreenTutorial_completionrow_heading'.tr,
                      style: _themeData.textTheme.headline4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'completionScreenTutorial_completionrow_message'.tr,
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
        identify: "completion_completeButton",
        shape: ShapeLightFocus.RRect,
        enableOverlayTab: false,
        enableTargetTab: false,
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
      ),
    );
  }

  void _addRewardPopupTutorialTargets() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "Target 3",
        shape: ShapeLightFocus.RRect,
        enableOverlayTab: false,
        enableTargetTab: false,
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
                      'completionTutorial_drawerExtension_heading'.tr,
                      style: _themeData.textTheme.headline4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'completionTutorial_drawerExtension_message'.tr,
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

class PreviousButton extends StatelessWidget {
  final Function onPressed;

  const PreviousButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphPressSwitch(
      onPressed: onPressed,
      width: 50,
      height: 50,
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
    return NeumorphPressSwitch(
      onPressed: onPressed,
      width: 50,
      height: 50,
      color: kDeepOrange,
      child: Icon(
        FontAwesomeIcons.arrowRight,
        color: kBackGroundWhite,
        size: 20,
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
              //TODO translate
              Text(
                "Welcome to Marbit",
                style: Theme.of(context).textTheme.headline4,
              ),
              //TODO translate
              Text("Do you want to watch an interactive introduction?",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 10,
                    child: NeumorphPressSwitch(
                      onPressed: () {
                        Get.back(result: true);
                      },
                      child: Text(
                        //TODO translate
                        "Lets go",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: kDeepOrange),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 20,
                    child: NeumorphPressSwitch(
                      onPressed: () {
                        Get.back(result: false);
                      },
                      child: Text(
                        //TODO translate
                        "I'll figure it out myself",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: kDeepOrange),
                      ),
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
