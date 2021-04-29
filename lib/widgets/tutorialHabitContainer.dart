import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/screens/screens.dart';
import 'package:Marbit/screens/tutorialHabitDetailScreen.dart';
import 'package:Marbit/util/util.dart';
import 'package:Marbit/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class TutorialHabitContainer extends StatelessWidget {
  final Function onChildPopped;

  const TutorialHabitContainer({Key key, @required this.onChildPopped})
      : super(key: key);

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
            habit: ContentController.tutorialHabit,
            onDetailScreenPopped: onChildPopped,
            onPressed: () {
              ContentController.tutorialHabit.addCompletionForToday(
                onCompletionGoalReached: () {
                  400.milliseconds.delay().then(
                    (value) {
                      Get.to(
                        () => RewardPopupScreen(
                            habit: ContentController.tutorialHabit,
                            isTutorial: true),
                      ).then((value) => onChildPopped());
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
  final Function onDetailScreenPopped;

  const TutorialContainer({
    Key key,
    this.habit,
    @required this.onPressed,
    @required this.onDetailScreenPopped,
  }) : super(key: key);

  @override
  _TutorialContainerState createState() => _TutorialContainerState();
}

class _TutorialContainerState extends State<TutorialContainer>
    with SingleTickerProviderStateMixin {
  final TutorialController _tutorialController = Get.find<TutorialController>();

  final List<double> containerSizeList =
      List.generate(ContentController.maxDailyCompletions, (index) => 15);

  @override
  Widget build(BuildContext context) {
    int _todaysHabitCompletions = widget.habit.getTodaysCompletions();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (_tutorialController.hasFinishedDetailScreenStep) return;
              Get.to(() => TutorialHabitDetailScreen(habit: widget.habit))
                  .then((value) => widget.onDetailScreenPopped());
            },
            child: Hero(
              tag: widget.habit.id,
              child: Container(
                key: _tutorialController.homeTutorialHabitContainerKey,
                height: 90,
                decoration: BoxDecoration(
                  color: Color(
                    widget.habit.habitColors["light"],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    color: kBackGroundWhite,
                                  ),
                            ),
                          ),
                          _tutorialController.hasFinishedDetailScreenStep
                              ? Container(
                                  key: _tutorialController.completionRowKey,
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
                                          width:
                                              index >= _todaysHabitCompletions
                                                  ? 15.0
                                                  : containerSizeList[index],
                                          height:
                                              index >= _todaysHabitCompletions
                                                  ? 15.0
                                                  : containerSizeList[index],
                                          decoration: BoxDecoration(
                                              color: index >=
                                                      _todaysHabitCompletions
                                                  ? kBackGroundWhite
                                                  : kDeepOrange,
                                              borderRadius:
                                                  BorderRadius.circular(3)),
                                          duration: Duration(milliseconds: 200),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(
                                  height: 20,
                                )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 17,
            right: 20,
            child: _tutorialController.hasFinishedDetailScreenStep
                ? BouncingButton(
                    onPressed: () {
                      setState(() {
                        _todaysHabitCompletions == containerSizeList.length
                            ? containerSizeList.last = 20.0
                            : containerSizeList[_todaysHabitCompletions] = 20.0;
                      });
                      widget.onPressed();
                    },
                    key: _tutorialController.completeButtonKey,
                    height: 56,
                    width: 56,
                    child: Icon(
                      FontAwesomeIcons.check,
                      // Icons.check_rounded,
                      size: 25,
                      color: kLightOrange,
                    ),
                  )
                : const SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}
