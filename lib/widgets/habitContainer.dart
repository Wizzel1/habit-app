import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:Marbit/models/habitModel.dart';
import 'package:Marbit/util/constants.dart';
import 'package:Marbit/widgets/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

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
  @override
  Widget build(BuildContext context) {
    int _todaysHabitCompletions = widget.habit.getTodaysCompletions();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Stack(
        children: [
          Hero(
            tag: widget.habit.id,
            child: GestureDetector(
              onTap: () {
                Get.to(() => HabitDetailScreen(
                      habit: widget.habit,
                      alterHeroTag: false,
                    ));
              },
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  boxShadow: [kBoxShadow],
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
                                  .headline5
                                  .copyWith(
                                    color: kBackGroundWhite,
                                  ),
                            ),
                          ),
                          Container(
                            height: 20.0,
                            width: widget.habit.completionGoal * 20.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.habit.completionGoal,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0, vertical: 2.0),
                                  child: index >= _todaysHabitCompletions
                                      ? Container(
                                          width: 15,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            color: kBackGroundWhite,
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  offset: const Offset(0, 3),
                                                  blurRadius: 1)
                                            ],
                                          ),
                                        )
                                      : InnerShadow(
                                          blur: 1,
                                          color: kBoxShadowBlack,
                                          offset: const Offset(1, 3),
                                          child: Container(
                                            width: 15,
                                            height: 15,
                                            decoration: BoxDecoration(
                                              color: kDeepOrange,
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                          ),
                                        ),
                                );
                              },
                            ),
                          ),
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
            child: BouncingButton(
              onPressed: () {
                widget.onPressed();
              },
              height: 56,
              width: 56,
              child: Icon(
                FontAwesomeIcons.check,
                // Icons.check_rounded,
                size: 25,
                color: kLightOrange,
              ),
            ),
          )
        ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Hero(
        tag: "all${habit.id}",
        child: GestureDetector(
          onTap: () {
            Get.to(() => HabitDetailScreen(
                  habit: habit,
                  alterHeroTag: true,
                ));
          },
          child: Container(
            height: 90,
            decoration: BoxDecoration(
                color: Color(
                  habit.habitColors["light"],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [kBoxShadow]),
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
                  Container(
                    height: 30,
                    child: ListView.builder(
                        itemCount: 7,
                        scrollDirection: Axis.horizontal,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: habit.scheduledWeekDays.contains(index + 1)
                                ? InnerShadow(
                                    blur: 1,
                                    color: kBoxShadowBlack,
                                    offset: const Offset(1, 5),
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          color:
                                              Color(habit.habitColors["deep"])),
                                      child: Center(
                                        child: Text(
                                          dayNames[index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              .copyWith(
                                                fontSize: 10,
                                                color: kBackGroundWhite,
                                              ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                        boxShadow: [kBoxShadow],
                                        borderRadius: BorderRadius.circular(3),
                                        color: kBackGroundWhite),
                                    child: Center(
                                      child: Text(
                                        dayNames[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .button
                                            .copyWith(
                                              fontSize: 10,
                                              color: Color(
                                                  habit.habitColors["deep"]),
                                            ),
                                      ),
                                    ),
                                  ),
                          );
                        }),
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
