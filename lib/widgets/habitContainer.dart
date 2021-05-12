import 'package:Marbit/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:Marbit/models/habitModel.dart';
import 'package:Marbit/util/constants.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:Marbit/widgets/bouncingButton.dart';

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
  AnimationController _buttonAnimController;
  Animation<Color> _colorTween;
  Animation<double> _pressAnimation;
  bool _switchedAnimations;

  @override
  void initState() {
    _buttonAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pressAnimation = Tween<double>(begin: 3.0, end: -3.0).animate(
      CurvedAnimation(
          parent: _buttonAnimController,
          curve: const Interval(0, 0.6, curve: Curves.easeInOut)),
    );
    _colorTween =
        ColorTween(begin: Color(0xFFFEFDFB), end: Color(0xFFFFAB4A)).animate(
      CurvedAnimation(
          parent: _buttonAnimController,
          curve: const Interval(0.6, 0.61, curve: Curves.linear)),
    );

    _buttonAnimController.addListener(() {
      if (_buttonAnimController.status == AnimationStatus.forward) {
        if (_buttonAnimController.value < 0.7) return;
        if (_switchedAnimations) return;
        setState(() {
          _pressAnimation = Tween<double>(begin: -3.0, end: 0.0).animate(
              CurvedAnimation(
                  parent: _buttonAnimController,
                  curve: const Interval(0.8, 1.0, curve: Curves.easeInOut)));
          _switchedAnimations = true;
        });
      }
      if (_buttonAnimController.status == AnimationStatus.reverse) {
        if (_buttonAnimController.value > 0.6) return;
        if (_switchedAnimations) return;
        setState(() {
          _pressAnimation = Tween<double>(begin: 3.0, end: -3.0).animate(
            CurvedAnimation(
                parent: _buttonAnimController,
                curve: const Interval(0, 0.6, curve: Curves.easeInOut)),
          );
          ;
          _switchedAnimations = true;
        });
      }
    });

    _buttonAnimController.addStatusListener((status) {
      setState(() {
        _switchedAnimations = false;
      });
    });

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
                await 200.milliseconds.delay();
                await Get.to(() => HabitDetailScreen(
                      habit: widget.habit,
                      alterHeroTag: false,
                    ));
                await 200.milliseconds.delay();
                await _buttonAnimController.reverse();
              },
              child: Neumorphic(
                style: kInactiveNeumorphStyle.copyWith(color: kLightOrange),
                child: Container(
                  height: 90,
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
                                        ? Neumorphic(
                                            style:
                                                kInactiveNeumorphStyle.copyWith(
                                              boxShape:
                                                  NeumorphicBoxShape.roundRect(
                                                      BorderRadius.circular(3)),
                                            ),
                                            child: Container(
                                              width: 15,
                                              height: 15,
                                            ),
                                          )
                                        : Neumorphic(
                                            style:
                                                kActiveNeumorphStyle.copyWith(
                                              boxShape:
                                                  NeumorphicBoxShape.roundRect(
                                                      BorderRadius.circular(3)),
                                            ),
                                            child: Container(
                                              width: 15,
                                              height: 15,
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
          ),
          Positioned(
            top: 17,
            right: 20,
            child: AnimatedBuilder(
              animation: _buttonAnimController,
              builder: (BuildContext context, Widget child) {
                return NeumorphicButton(
                  onPressed: () {
                    widget.onPressed();
                  },
                  minDistance: 0.0,
                  style: kInactiveNeumorphStyle.copyWith(
                      depth: _pressAnimation.value, color: _colorTween.value),
                  padding: EdgeInsets.zero,
                  child: Container(
                    height: 56,
                    width: 56,
                    child: Icon(
                      FontAwesomeIcons.check,
                      // Icons.check_rounded,
                      size: 25,
                      color: kLightOrange,
                    ),
                  ),
                );
              },
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
          child: Neumorphic(
            style: kInactiveNeumorphStyle.copyWith(color: kLightOrange),
            child: Container(
              height: 90,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                      style: kActiveNeumorphStyle.copyWith(
                                          boxShape:
                                              NeumorphicBoxShape.roundRect(
                                                  BorderRadius.circular(3))),
                                      child: Container(
                                        height: 25,
                                        width: 25,
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
                                      style: kInactiveNeumorphStyle.copyWith(
                                          boxShape:
                                              NeumorphicBoxShape.roundRect(
                                                  BorderRadius.circular(3))),
                                      child: Container(
                                        height: 25,
                                        width: 25,
                                        child: Center(
                                          child: Text(
                                            dayNames[index],
                                            style: Theme.of(context)
                                                .textTheme
                                                .button
                                                .copyWith(
                                                  fontSize: 10,
                                                  color: Color(habit
                                                      .habitColors["deep"]),
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
      ),
    );
  }
}
