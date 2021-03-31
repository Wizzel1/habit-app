import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/screens/rewardPopupScreen.dart';
import 'package:Marbit/util/constants.dart';
import 'package:Marbit/widgets/widgets.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:admob_consent/admob_consent.dart';

class TodaysHabitScreen extends StatefulWidget {
  const TodaysHabitScreen({Key key}) : super(key: key);
  @override
  _TodaysHabitScreenState createState() => _TodaysHabitScreenState();
}

class _TodaysHabitScreenState extends State<TodaysHabitScreen> {
  //TODO create binding for controllers
  final ContentController _contentController =
      Get.put<ContentController>(ContentController());
  final TutorialController _tutorialController =
      Get.put<TutorialController>(TutorialController());
  final ScrollController _scrollContoller = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _contentController.initializeContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          Positioned(
              bottom: (screenSize.height / 2) - 45,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                    color: kLightOrange,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                height: 90,
                width: 15,
                child: const RotatedBox(
                    quarterTurns: -1, child: Center(child: Text("Menu"))),
              )),
          Positioned.fill(
            child: false
                ? TutorialHabitContainer()
                : Obx(
                    () => ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemCount: _contentController.todaysList.length,
                      itemBuilder: (BuildContext context, int index) {
                        Habit tappedHabit =
                            _contentController.todaysList[index];
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
                                          _contentController
                                              .completeHabitAt(index);
                                          Navigator.of(context).push(
                                            PageRouteBuilder(
                                              opaque: false,
                                              pageBuilder:
                                                  (BuildContext context, _,
                                                          __) =>
                                                      RewardPopupScreen(
                                                rewardList:
                                                    tappedHabit.rewardList,
                                              ),
                                            ),
                                          );
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
                      separatorBuilder: (BuildContext context, int index) {
                        if (index % 3 == 0)
                          return AdController.getAdaptiveBannerAd(context);
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
