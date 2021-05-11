import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:Marbit/models/habitModel.dart';
import 'package:Marbit/util/constants.dart';
import 'package:Marbit/widgets/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
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
  Animation<double> _popupSequence;
  AnimationController _buttonAnimController;

  @override
  void initState() {
    _buttonAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _popupSequence = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 1.2), weight: 1.0),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.2, end: 0.0), weight: 0.3),
    ]).animate(
      CurvedAnimation(parent: _buttonAnimController, curve: Curves.easeInOut),
    );
    super.initState();
  }

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
              onTap: () async {
                await _buttonAnimController.forward();
                await Get.to(() => HabitDetailScreen(
                      habit: widget.habit,
                      alterHeroTag: false,
                    ));
                await 300.milliseconds.delay();
                await _buttonAnimController.reverse();
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
                                      : Neumorphic(
                                          style: NeumorphicStyle(
                                            lightSource: kLightSource,
                                            depth: -2.0,
                                            intensity: 1.0,
                                            shadowLightColor:
                                                Colors.transparent,
                                            shadowLightColorEmboss:
                                                Colors.transparent,
                                            color: kDeepOrange,
                                            shape: NeumorphicShape.flat,
                                            boxShape:
                                                NeumorphicBoxShape.roundRect(
                                                    BorderRadius.circular(3)),
                                          ),
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
            child: ScaleTransition(
              scale: _popupSequence,
              child: CustomNeumorphButton(
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
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: habit.scheduledWeekDays.contains(index + 1)
                                ? Neumorphic(
                                    style: NeumorphicStyle(
                                      lightSource: kLightSource,
                                      depth: -2.0,
                                      intensity: 0.8,
                                      shadowLightColor: Colors.transparent,
                                      shadowLightColorEmboss:
                                          Colors.transparent,
                                      color: kDeepOrange,
                                      shape: NeumorphicShape.flat,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(3)),
                                    ),
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
                                : Neumorphic(
                                    style: NeumorphicStyle(
                                      lightSource: kLightSource,
                                      depth: 2.0,
                                      intensity: 0.8,
                                      shadowLightColor: Colors.transparent,
                                      shadowLightColorEmboss:
                                          Colors.transparent,
                                      color: kBackGroundWhite,
                                      shape: NeumorphicShape.flat,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(3)),
                                    ),
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                          boxShadow: [kBoxShadow],
                                          borderRadius:
                                              BorderRadius.circular(3),
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
