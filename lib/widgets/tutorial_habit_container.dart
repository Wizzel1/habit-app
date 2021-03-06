import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/screens/screens.dart';
import 'package:Marbit/util/util.dart';
import 'package:Marbit/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

class TutorialHabitContainer extends StatefulWidget {
  final Function onChildPopped;

  const TutorialHabitContainer({Key? key, required this.onChildPopped})
      : super(key: key);

  @override
  _TutorialHabitContainerState createState() => _TutorialHabitContainerState();
}

class _TutorialHabitContainerState extends State<TutorialHabitContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Container(
            color: kBackGroundWhite,
            height: 120,
            width: double.infinity,
            child: CompletableHabitContainer(
              isTutorialContainer: true,
              habit: ContentController.tutorialHabit,
              onDetailScreenPopped: widget.onChildPopped,
              onPressed: () {
                setState(() {
                  ContentController.tutorialHabit.addCompletionForToday(
                    onCompletionGoalReached: () async {
                      await 400.milliseconds.delay();
                      await Get.to(
                        () => RewardPopupScreen(
                            habit: ContentController.tutorialHabit,
                            isTutorial: true),
                      );
                      widget.onChildPopped();
                    },
                  );
                });
              },
            )),
      ],
    );
  }
}
