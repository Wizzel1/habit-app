import 'package:Marbit/controllers/contentController.dart';
import 'package:Marbit/controllers/tutorialController.dart';
import 'package:Marbit/screens/rewardPopupScreen.dart';
import 'package:Marbit/util/constants.dart';
import 'package:Marbit/widgets/habitContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TutorialHabitContainer extends StatelessWidget {
  //TODO: create a binding for this controller and replace with get.find
  final TutorialController _tutorialController =
      Get.put<TutorialController>(TutorialController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        Container(
          color: kBackGroundWhite,
          height: 120,
          width: double.infinity,
          child: CompletableHabitContainer(
              optionalTutorialKey:
                  _tutorialController.homeTutorialHabitContainerKey,
              habit: ContentController.tutorialHabit,
              onPressed: () {
                ContentController.tutorialHabit.addCompletionForToday(
                    onCompletionGoalReached: () {
                  400.milliseconds.delay().then((value) {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) =>
                            RewardPopupScreen(
                          rewardList:
                              ContentController.tutorialHabit.rewardList,
                        ),
                      ),
                    );
                  });
                });
              }),
        ),
      ],
    );
  }
}
