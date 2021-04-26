import 'package:Marbit/controllers/dateController.dart';
import 'package:Marbit/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_funding_choices/flutter_funding_choices.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/screens/rewardPopupScreen.dart';
import 'package:Marbit/widgets/widgets.dart';

class TodaysHabitScreen extends StatefulWidget {
  const TodaysHabitScreen({Key key}) : super(key: key);
  @override
  _TodaysHabitScreenState createState() => _TodaysHabitScreenState();
}

class _TodaysHabitScreenState extends State<TodaysHabitScreen> {
  ScrollController _scrollContoller;
  ContentController _contentController = Get.find<ContentController>();
  TutorialController _tutorialController = Get.find<TutorialController>();

  @override
  void initState() {
    _scrollContoller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ConsentInformation consentInfo =
          await FlutterFundingChoices.requestConsentInformation();
      //TODO add IOS consent
      if (consentInfo.isConsentFormAvailable &&
          consentInfo.consentStatus == ConsentStatus.REQUIRED_ANDROID) {
        await FlutterFundingChoices.showConsentForm();
        // You can check the result by calling `FlutterFundingChoices.requestConsentInformation()` again !
      }
      resumeTutorial();
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollContoller.dispose();
    super.dispose();
  }

  void resumeTutorial() {
    _tutorialController.resumeToLatestTutorialStep(context);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: GetBuilder<TutorialController>(
        id: TutorialController.todaysHabitsBuilderID,
        builder: (TutorialController controller) {
          return Stack(
            children: [
              Positioned(
                  bottom: (screenSize.height / 2) - 45,
                  right: 0,
                  child: controller.hasFinishedCompletionStep
                      ? DrawerExtension(
                          key: _tutorialController.drawerExtensionKey,
                          color: kLightOrange,
                        )
                      : const SizedBox.shrink()),
              Positioned.fill(
                child: AnimatedSwitcher(
                  switchInCurve: Curves.ease,
                  switchOutCurve: Curves.ease,
                  duration: const Duration(milliseconds: 300),
                  child: controller.hasFinishedDrawerExtensionStep
                      ? Obx(
                          () => ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                                _contentController.todaysHabitList.length,
                            itemBuilder: (BuildContext context, int index) {
                              Habit tappedHabit =
                                  _contentController.todaysHabitList[index];
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: CompletableHabitContainer(
                                      habit: tappedHabit,
                                      onPressed: () {
                                        tappedHabit.addCompletionForToday(
                                          onCompletionGoalReached: () {
                                            400.milliseconds.delay().then(
                                              (value) {
                                                Get.to(() => RewardPopupScreen(
                                                      isTutorial: false,
                                                      habit: tappedHabit,
                                                    ));
                                              },
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              if (index % 3 == 0)
                                return AdController.getAdaptiveBannerAd(
                                    context);
                              return const SizedBox.shrink();
                            },
                          ),
                        )
                      : TutorialHabitContainer(onChildPopped: resumeTutorial),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
