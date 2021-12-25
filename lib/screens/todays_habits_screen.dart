import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/screens/screens.dart';
import 'package:Marbit/util/util.dart';
import 'package:Marbit/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_funding_choices/flutter_funding_choices.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class TodaysHabitScreen extends StatefulWidget {
  const TodaysHabitScreen({Key key}) : super(key: key);
  @override
  _TodaysHabitScreenState createState() => _TodaysHabitScreenState();
}

class _TodaysHabitScreenState extends State<TodaysHabitScreen> {
  ScrollController _scrollContoller;
  final ContentController _contentController = Get.find<ContentController>();
  final TutorialController _tutorialController = Get.find<TutorialController>();

  @override
  void initState() {
    _scrollContoller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final ConsentInformation consentInfo =
          await FlutterFundingChoices.requestConsentInformation();

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
    final Size screenSize = MediaQuery.of(context).size;
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
                              final Habit tappedHabit =
                                  _contentController.todaysHabitList[index];
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: CompletableHabitContainer(
                                      onDetailScreenPopped: () {},
                                      isTutorialContainer: false,
                                      habit: tappedHabit,
                                      onPressed: () async {
                                        await tappedHabit.addCompletionForToday(
                                          onCompletionGoalReached: () async {
                                            await 400.milliseconds.delay();
                                            await Get.to(
                                                () => RewardPopupScreen(
                                                      isTutorial: false,
                                                      habit: tappedHabit,
                                                    ));
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
                              if (index % 3 == 0) {
                                return AdController.getAdaptiveBannerAd(
                                    context);
                              }
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
