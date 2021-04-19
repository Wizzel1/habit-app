import 'package:Marbit/controllers/contentController.dart';
import 'package:Marbit/controllers/tutorialController.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/screens/rewardPopupScreen.dart';
import 'package:Marbit/screens/screens.dart';
import 'package:Marbit/util/constants.dart';
import 'package:Marbit/widgets/habitContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TutorialHabitContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Container(
          color: kBackGroundWhite,
          height: 120,
          width: double.infinity,
          child: TutorialContainer(
            isTutorialContainer: true,
            habit: ContentController.tutorialHabit,
            onPressed: () {
              ContentController.tutorialHabit.addCompletionForToday(
                onCompletionGoalReached: () {
                  400.milliseconds.delay().then(
                    (value) {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, _, __) =>
                              RewardPopupScreen(
                            habit: ContentController.tutorialHabit,
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
      ],
    );
  }
}

class TutorialContainer extends StatefulWidget {
  final Habit habit;
  final Function onPressed;
  final bool isTutorialContainer;

  const TutorialContainer({
    Key key,
    this.habit,
    @required this.onPressed,
    @required this.isTutorialContainer,
  }) : super(key: key);

  @override
  _TutorialContainerState createState() => _TutorialContainerState();
}

class _TutorialContainerState extends State<TutorialContainer>
    with SingleTickerProviderStateMixin {
  final List<double> containerSizeList =
      List.generate(ContentController.maxDailyCompletions, (index) => 15);

  @override
  Widget build(BuildContext context) {
    int _todaysHabitCompletions = widget.habit.getTodaysCompletions();

    return Hero(
      tag: widget.habit.id,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HabitDetailScreen(
                habit: widget.habit,
                alterHeroTag: false,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          child: Container(
            key: widget.isTutorialContainer
                ? Get.find<TutorialController>().homeTutorialHabitContainerKey
                : null,
            height: 90,
            decoration: BoxDecoration(
              color: Color(
                widget.habit.habitColors["light"],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        type: MaterialType.transparency,
                        child: Text(
                          widget.habit.title,
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                color: kBackGroundWhite,
                              ),
                        ),
                      ),
                      Container(
                        key: widget.isTutorialContainer
                            ? Get.find<TutorialController>().completionRowKey
                            : null,
                        height: 20.0,
                        width: widget.habit.completionGoal * 20.0,
                        child: Stack(
                          children: List.generate(
                            widget.habit.completionGoal,
                            (index) => Positioned(
                              left: index * 20.0,
                              bottom: 0,
                              child: AnimatedContainer(
                                curve: Curves.bounceInOut,
                                onEnd: () {
                                  setState(() {
                                    containerSizeList[index] = 15.0;
                                  });
                                },
                                width: index >= _todaysHabitCompletions
                                    ? 15.0
                                    : containerSizeList[index],
                                height: index >= _todaysHabitCompletions
                                    ? 15.0
                                    : containerSizeList[index],
                                decoration: BoxDecoration(
                                    color: index >= _todaysHabitCompletions
                                        ? kBackGroundWhite
                                        : kDeepOrange,
                                    borderRadius: BorderRadius.circular(3)),
                                duration: Duration(milliseconds: 200),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  MaterialButton(
                    key: widget.isTutorialContainer
                        ? Get.find<TutorialController>().completeButtonKey
                        : null,
                    elevation: 0,
                    minWidth: 0,
                    onPressed: () {
                      setState(() {
                        _todaysHabitCompletions == containerSizeList.length
                            ? containerSizeList.last = 20.0
                            : containerSizeList[_todaysHabitCompletions] = 20.0;
                      });
                      widget.onPressed();
                    },
                    color: kBackGroundWhite,
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                      Icons.check_rounded,
                      size: 36,
                      color: kDeepOrange,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
