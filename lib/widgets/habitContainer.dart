import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:Marbit/models/habitModel.dart';
import 'package:Marbit/util/constants.dart';
import 'package:Marbit/widgets/widgets.dart';

class CompletableHabitContainer extends StatefulWidget {
  final Habit habit;
  final Function onPressed;

  const CompletableHabitContainer({
    Key key,
    this.habit,
    @required this.onPressed,
  }) : super(key: key);

  @override
  _CompletableHabitContainerState createState() =>
      _CompletableHabitContainerState();
}

class _CompletableHabitContainerState extends State<CompletableHabitContainer>
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Container(
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
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                color: kBackGroundWhite,
                              ),
                        ),
                      ),
                      Container(
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
                  BouncingWidget(
                    onPress: () {
                      setState(() {
                        _todaysHabitCompletions == containerSizeList.length
                            ? containerSizeList.last = 20.0
                            : containerSizeList[_todaysHabitCompletions] = 20.0;
                      });
                      widget.onPressed();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: kBackGroundWhite,
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        Icons.check_rounded,
                        size: 36,
                        color: kDeepOrange,
                      ),
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

class AllHabitContainer extends StatelessWidget {
  final Habit habit;

  const AllHabitContainer({
    Key key,
    this.habit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "all${habit.id}",
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HabitDetailScreen(
                habit: habit,
                alterHeroTag: true,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: Color(
                habit.habitColors["light"],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    type: MaterialType.transparency,
                    child: Text(
                      habit.title,
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            color: kBackGroundWhite,
                          ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                      7,
                      (index) => Padding(
                        padding: EdgeInsets.only(right: index == 6 ? 0 : 6),
                        child: Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: habit.scheduledWeekDays.contains(index + 1)
                                  ? Color(habit.habitColors["deep"])
                                  : kBackGroundWhite),
                          child: Center(
                            child: Text(
                              dayNames[index],
                              style:
                                  Theme.of(context).textTheme.button.copyWith(
                                        fontSize: 10,
                                        color: habit.scheduledWeekDays
                                                .contains(index + 1)
                                            ? kBackGroundWhite
                                            : Color(habit.habitColors["deep"]),
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
