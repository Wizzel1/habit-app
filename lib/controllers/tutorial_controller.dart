import 'dart:async';

import 'package:Marbit/services/local_storage.dart';
import 'package:Marbit/util/constants.dart';
import 'package:Marbit/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialController extends GetxController {
  List<TargetFocus> targets = [];
  AutoScrollController? tutorialHabitDetailScrollController;
  final Duration scrollDuration = const Duration(milliseconds: 500);

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

  static const int scheduleScrollIndex = 1;
  static const int completionGoalScrollIndex = 2;
  static const int notificationTimesScrollIndex = 3;
  static const int editButtonScrollIndex = 4;
  static const int rewardListScrollIndex = 5;
  static const int statisticsElementScrollIndex = 6;

  late TutorialCoachMark tutorial;
  final double targetFocusRadius = 15;
  final Duration _focusAnimationDuration = const Duration(milliseconds: 400);

  // -- HabitDetailScreen Keys --
  final GlobalKey scheduleRowKey = GlobalKey();
  final GlobalKey completionGoalKey = GlobalKey();
  final GlobalKey notificationTimesKey = GlobalKey();
  final GlobalKey editButtonKey = GlobalKey();
  final GlobalKey rewardListKey = GlobalKey();
  final GlobalKey statisticsElementKey = GlobalKey();

  // -- HomeScreen Step Keys --
  final GlobalKey homeTutorialHabitContainerKey = GlobalKey();
  final GlobalKey completionRowKey = GlobalKey();

  // -- Completion Step Keys --
  final GlobalKey completeButtonKey = GlobalKey();

  // -- Finished tutorial Step --
  final GlobalKey drawerExtensionKey = GlobalKey();

  @override
  void onInit() {
    tutorialHabitDetailScrollController = AutoScrollController(
        viewportBoundaryGetter: () => const Rect.fromLTRB(0, 0, 0, 0),
        axis: Axis.vertical,
        suggestedRowHeight: 400);
    super.onInit();
  }

  TargetFocus _createTargetFocus(
      {String? identifier,
      GlobalKey? keyTarget,
      required TargetContent content}) {
    return TargetFocus(
      identify: identifier,
      shape: ShapeLightFocus.RRect,
      enableTargetTab: false,
      radius: targetFocusRadius,
      keyTarget: keyTarget,
      contents: [content],
    );
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

  Future<void> _showWelcomeScreen(BuildContext context) async {
    if (hasSeenWelcomeScreen) return;

    final bool? wantToWatchTutorial = await Get.to<bool>(const WelcomeScreen());

    hasSeenWelcomeScreen = true;

    await LocalStorageService.saveTutorialProgress(
        "hasSeenWelcomeScreen", hasSeenWelcomeScreen);

    if (wantToWatchTutorial == null || !wantToWatchTutorial) {
      hasFinishedDetailScreenStep = true;
      hasFinishedHomeScreenStep = true;
      hasFinishedCompletionStep = true;
      hasFinishedDrawerExtensionStep = true;
      await LocalStorageService.saveTutorialProgress(
          "hasFinishedHomeScreenStep", hasFinishedHomeScreenStep);
      await LocalStorageService.saveTutorialProgress(
          "hasFinishedDetailScreenStep", hasFinishedDetailScreenStep);
      await LocalStorageService.saveTutorialProgress(
          "hasFinishedCompletionStep", hasFinishedCompletionStep);
      await LocalStorageService.saveTutorialProgress(
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
      onFinish: () async {
        hasFinishedHomeScreenStep = true;
        await LocalStorageService.saveTutorialProgress(
            "hasFinishedHomeScreenStep", hasFinishedHomeScreenStep);
      },
      onClickTarget: (target) {},
      onSkip: () async {
        hasFinishedHomeScreenStep = true;
        await LocalStorageService.saveTutorialProgress(
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
      onFinish: () async {
        hasFinishedDetailScreenStep = true;
        await LocalStorageService.saveTutorialProgress(
            "hasFinishedDetailScreenStep", hasFinishedDetailScreenStep);
        update([habitDetailBuilderID, todaysHabitsBuilderID, true]);
      },
      onClickTarget: (target) {},
      onSkip: () async {
        hasFinishedDetailScreenStep = true;
        await LocalStorageService.saveTutorialProgress(
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
      onFinish: () async {
        hasFinishedCompletionStep = true;
        await LocalStorageService.saveTutorialProgress(
            "hasFinishedCompletionStep", hasFinishedCompletionStep);
      },
      onClickTarget: (target) {},
      onSkip: () async {
        hasFinishedCompletionStep = true;
        await LocalStorageService.saveTutorialProgress(
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
      onFinish: () async {
        hasFinishedDrawerExtensionStep = true;
        await LocalStorageService.saveTutorialProgress(
            "hasFinishedDrawerExtensionStep", hasFinishedDrawerExtensionStep);
        update([innerDrawerBuilderID, todaysHabitsBuilderID, true]);
      },
      onClickTarget: (target) {},
      onSkip: () async {
        hasFinishedDrawerExtensionStep = true;
        await LocalStorageService.saveTutorialProgress(
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
      _createTargetFocus(
        identifier: "Target 1",
        keyTarget: homeTutorialHabitContainerKey,
        content: TargetContent(
          child: ContentContainer(
            heading: 'homeScreenTutorial_container_heading'.tr,
            message: 'homeScreenTutorial_container_message'.tr,
            buttonRow: ButtonRow(
              onNextTapped: _nextTutorialStep,
            ),
          ),
        ),
      ),
    );
    targets.add(
      _createTargetFocus(
        identifier: "Target 1",
        keyTarget: homeTutorialHabitContainerKey,
        content: TargetContent(
          child: ContentContainer(
            heading: 'homeScreenTutorial_details_heading'.tr,
            message: 'homeScreenTutorial_details_message'.tr,
            buttonRow: ButtonRow(
              onNextTapped: _nextTutorialStep,
            ),
          ),
        ),
      ),
    );
  }

  void _addHabitDetailScreenTargets() {
    targets.clear();
    targets.add(
      _createTargetFocus(
        identifier: 'detail_scheduleRowKey',
        keyTarget: scheduleRowKey,
        content: TargetContent(
          child: ContentContainer(
            heading: 'detailScreenTutorial_scheduleRowKey_heading'.tr,
            message: 'detailScreenTutorial_scheduleRowKey_message'.tr,
            tapMessage: 'detailScreenTutorial_scheduleRowKey_tap'.tr,
            holdMessage: 'detailScreenTutorial_scheduleRowKey_hold'.tr,
            buttonRow: ButtonRow(
              onNextTapped: () {
                tutorialHabitDetailScrollController!.scrollToIndex(
                    completionGoalScrollIndex,
                    duration: scrollDuration,
                    preferPosition: AutoScrollPosition.begin);
                _nextTutorialStep();
              },
            ),
          ),
        ),
      ),
    );
    targets.add(
      _createTargetFocus(
        identifier: 'detail_completionGoal',
        keyTarget: completionGoalKey,
        content: TargetContent(
          child: ContentContainer(
            heading: 'detailScreenTutorial_completionGoalKey_heading'.tr,
            message: 'detailScreenTutorial_completionGoalKey_message'.tr,
            buttonRow: ButtonRow(
              onPreviousTapped: () {
                tutorialHabitDetailScrollController!.scrollToIndex(
                    scheduleScrollIndex,
                    duration: scrollDuration,
                    preferPosition: AutoScrollPosition.begin);
                _previousTutorialStep();
              },
              onNextTapped: () {
                tutorialHabitDetailScrollController!.scrollToIndex(
                    notificationTimesScrollIndex,
                    duration: scrollDuration,
                    preferPosition: AutoScrollPosition.begin);
                _nextTutorialStep();
              },
            ),
          ),
        ),
      ),
    );
    targets.add(
      _createTargetFocus(
        identifier: 'detail_notificationTimesKey',
        keyTarget: notificationTimesKey,
        content: TargetContent(
          child: ContentContainer(
            heading: 'detailScreenTutorial_notificationTimesKey_heading'.tr,
            message: 'detailScreenTutorial_notificationTimesKey_message'.tr,
            tapMessage: 'detailScreenTutorial_notificationTimesKey_tap'.tr,
            holdMessage: 'detailScreenTutorial_notificationTimesKey_hold'.tr,
            buttonRow: ButtonRow(
              onPreviousTapped: () {
                tutorialHabitDetailScrollController!.scrollToIndex(
                    completionGoalScrollIndex,
                    duration: scrollDuration,
                    preferPosition: AutoScrollPosition.begin);
                _previousTutorialStep();
              },
              onNextTapped: () {
                tutorialHabitDetailScrollController!.scrollToIndex(
                    rewardListScrollIndex,
                    duration: scrollDuration,
                    preferPosition: AutoScrollPosition.end);
                _nextTutorialStep();
              },
            ),
          ),
        ),
      ),
    );

    targets.add(
      _createTargetFocus(
        identifier: "detail_rewardListKey",
        keyTarget: rewardListKey,
        content: TargetContent(
          align: ContentAlign.top,
          child: ContentContainer(
            heading: 'detailScreenTutorial_rewardList_heading'.tr,
            message: 'detailScreenTutorial_rewardList_message'.tr,
            buttonRow: ButtonRow(
              onPreviousTapped: () {
                tutorialHabitDetailScrollController!.scrollToIndex(
                    notificationTimesScrollIndex,
                    duration: scrollDuration,
                    preferPosition: AutoScrollPosition.begin);
                _previousTutorialStep();
              },
              onNextTapped: () {
                tutorialHabitDetailScrollController!.scrollToIndex(
                    statisticsElementScrollIndex,
                    duration: scrollDuration,
                    preferPosition: AutoScrollPosition.end);
                _nextTutorialStep();
              },
            ),
          ),
        ),
      ),
    );
    targets.add(
      _createTargetFocus(
        identifier: "detail_statisticsElementKey",
        keyTarget: statisticsElementKey,
        content: TargetContent(
            align: ContentAlign.top,
            child: ContentContainer(
              heading: 'detailScreenTutorial_statistics_heading'.tr,
              message: 'detailScreenTutorial_statistics_message'.tr,
              holdMessage: 'detailScreenTutorial_statistics_hold'.tr,
              buttonRow: ButtonRow(
                onPreviousTapped: () {
                  tutorialHabitDetailScrollController!.scrollToIndex(
                      rewardListScrollIndex,
                      duration: scrollDuration,
                      preferPosition: AutoScrollPosition.end);
                  _previousTutorialStep();
                },
                onNextTapped: () {
                  tutorialHabitDetailScrollController!.scrollToIndex(
                      editButtonScrollIndex,
                      duration: scrollDuration,
                      preferPosition: AutoScrollPosition.middle);
                  _nextTutorialStep();
                },
              ),
            )),
      ),
    );
    targets.add(
      _createTargetFocus(
        identifier: "detail_editButtonKey",
        keyTarget: editButtonKey,
        content: TargetContent(
          align: ContentAlign.top,
          child: ContentContainer(
            heading: 'detailScreenTutorial_editButton_heading'.tr,
            message: 'detailScreenTutorial_editButton_message'.tr,
            buttonRow: ButtonRow(
              onNextTapped: _nextTutorialStep,
              onPreviousTapped: _previousTutorialStep,
            ),
          ),
        ),
      ),
    );
  }

  void _addCompletionTutorialTargets() {
    targets.clear();
    targets.add(
      _createTargetFocus(
        identifier: "Target 2",
        keyTarget: completionRowKey,
        content: TargetContent(
          child: ContentContainer(
            heading: 'completionScreenTutorial_completionrow_heading'.tr,
            message: 'completionScreenTutorial_completionrow_message'.tr,
            buttonRow: ButtonRow(
              onNextTapped: _nextTutorialStep,
              onPreviousTapped: _previousTutorialStep,
            ),
          ),
        ),
      ),
    );
    targets.add(
      _createTargetFocus(
        identifier: "completion_completeButton 3",
        keyTarget: completeButtonKey,
        content: TargetContent(
          child: ContentContainer(
            heading: 'completionStepTutorial_complete_heading'.tr,
            message: 'completionStepTutorial_complete_message'.tr,
            buttonRow: ButtonRow(onNextTapped: _nextTutorialStep),
          ),
        ),
      ),
    );
  }

  void _addRewardPopupTutorialTargets() {
    targets.clear();
    targets.add(
      _createTargetFocus(
        identifier: "Target 3",
        keyTarget: drawerExtensionKey,
        content: TargetContent(
          child: ContentContainer(
            heading: 'completionTutorial_drawerExtension_heading'.tr,
            message: 'completionTutorial_drawerExtension_message'.tr,
            buttonRow: ButtonRow(onNextTapped: _nextTutorialStep),
          ),
        ),
      ),
    );
  }
}

class ContentContainer extends StatelessWidget {
  final String? heading;
  final String? message;
  final ButtonRow? buttonRow;
  final String? tapMessage;
  final String? holdMessage;

  const ContentContainer(
      {Key? key,
      this.heading,
      this.message,
      this.buttonRow,
      this.tapMessage,
      this.holdMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData _themeData = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          heading!,
          style: _themeData.textTheme.headline4,
          textAlign: TextAlign.center,
        ),
        if (message != null)
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              message!,
              style: _themeData.textTheme.caption,
              textAlign: TextAlign.center,
            ),
          ),
        const SizedBox(height: 20),
        if (tapMessage != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${'tap'.tr} ",
                style: _themeData.textTheme.button!
                    .copyWith(color: kBackGroundWhite),
              ),
              Text(
                tapMessage!,
                style: _themeData.textTheme.caption,
                textAlign: TextAlign.center,
              )
            ],
          ),
        if (holdMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${'hold'.tr} ",
                  style: _themeData.textTheme.button!
                      .copyWith(color: kBackGroundWhite),
                ),
                Text(
                  holdMessage!,
                  style: _themeData.textTheme.caption,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        buttonRow!,
      ],
    );
  }
}

class ButtonRow extends StatelessWidget {
  final VoidCallback? onPreviousTapped;
  final VoidCallback? onNextTapped;

  const ButtonRow({Key? key, this.onPreviousTapped, this.onNextTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (onPreviousTapped != null)
              PreviousButton(
                onPressed: onPreviousTapped,
              )
            else
              const SizedBox.shrink(),
            const SizedBox(width: 50),
            if (onNextTapped != null)
              NextButton(
                onPressed: onNextTapped,
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class PreviousButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const PreviousButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphPressSwitch(
      onPressed: onPressed,
      width: 50,
      height: 50,
      style: kInactiveNeumorphStyle,
      child: const Icon(
        FontAwesomeIcons.arrowLeft,
        color: kDeepOrange,
        size: 20,
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const NextButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphPressSwitch(
      onPressed: onPressed,
      width: 50,
      height: 50,
      style: kInactiveNeumorphStyle.copyWith(color: kDeepOrange),
      child: const Icon(
        FontAwesomeIcons.arrowRight,
        color: kBackGroundWhite,
        size: 20,
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightOrange,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'welcomeScreen_welcome_heading'.tr,
                style: Theme.of(context).textTheme.headline4,
              ),
              Text('welcomeScreen_welcome_message'.tr,
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
                      style: kInactiveNeumorphStyle,
                      child: Text(
                        'welcomeScreen_startButton_title'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .button!
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
                      style: kInactiveNeumorphStyle,
                      child: Text(
                        'welcomeScreen_skipButton_title'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .button!
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
