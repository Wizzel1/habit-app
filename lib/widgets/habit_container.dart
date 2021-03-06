import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/models/habit.dart';
import 'package:Marbit/screens/screens.dart';
import 'package:Marbit/util/constants.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CompletableHabitContainer extends StatefulWidget {
  final Habit? habit;
  final VoidCallback onPressed;
  final bool isTutorialContainer;
  final TutorialController _tutorialController = Get.find<TutorialController>();
  final Function? onDetailScreenPopped;

  CompletableHabitContainer({
    Key? key,
    this.habit,
    required this.onPressed,
    required this.isTutorialContainer,
    this.onDetailScreenPopped,
  }) : super(key: key);

  @override
  _CompletableHabitContainerState createState() =>
      _CompletableHabitContainerState();
}

class _CompletableHabitContainerState extends State<CompletableHabitContainer>
    with SingleTickerProviderStateMixin {
  AnimationController? _buttonAnimController;
  Animation<Color?>? _colorTween;
  Animation<double>? _pressAnimation;
  late bool _switchedAnimations;

  @override
  void initState() {
    _buttonAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pressAnimation = Tween<double>(begin: 3.0, end: -3.0).animate(
      CurvedAnimation(
          parent: _buttonAnimController!,
          curve: const Interval(0, 0.6, curve: Curves.easeInOut)),
    );
    _colorTween =
        ColorTween(begin: const Color(0xFFFEFDFB), end: const Color(0xFFFFAB4A))
            .animate(
      CurvedAnimation(
          parent: _buttonAnimController!, curve: const Interval(0.6, 0.61)),
    );

    _buttonAnimController!.addListener(() {
      if (_buttonAnimController!.status == AnimationStatus.forward) {
        if (_buttonAnimController!.value < 0.7) return;
        if (_switchedAnimations) return;
        setState(() {
          _pressAnimation = Tween<double>(begin: -3.0, end: 0.0).animate(
              CurvedAnimation(
                  parent: _buttonAnimController!,
                  curve: const Interval(0.8, 1.0, curve: Curves.easeInOut)));
          _switchedAnimations = true;
        });
      }
      if (_buttonAnimController!.status == AnimationStatus.reverse) {
        if (_buttonAnimController!.value > 0.6) return;
        if (_switchedAnimations) return;
        setState(() {
          _pressAnimation = Tween<double>(begin: 3.0, end: -3.0).animate(
            CurvedAnimation(
                parent: _buttonAnimController!,
                curve: const Interval(0, 0.6, curve: Curves.easeInOut)),
          );

          _switchedAnimations = true;
        });
      }
    });

    _buttonAnimController!.addStatusListener((status) {
      setState(() {
        _switchedAnimations = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _buttonAnimController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int? _todaysHabitCompletions = widget.habit!.getTodaysCompletions();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Stack(
        children: [
          Hero(
            tag: widget.habit!.id!,
            child: GestureDetector(
              onTap: () async {
                await _buttonAnimController!.forward();
                await 200.milliseconds.delay();
                await Get.to(() => HabitDetailScreen(
                      isTutorialScreen: widget.isTutorialContainer,
                      habit: widget.habit,
                      alterHeroTag: false,
                    ));
                widget.onDetailScreenPopped!();
                if (_buttonAnimController == null) return;
                await 200.milliseconds.delay();
                await _buttonAnimController?.reverse();
              },
              child: Neumorphic(
                style: kInactiveNeumorphStyle.copyWith(color: kLightOrange),
                child: SizedBox(
                  key: widget.isTutorialContainer
                      ? widget._tutorialController.homeTutorialHabitContainerKey
                      : null,
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
                                widget.habit!.title!,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                      color: kBackGroundWhite,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            if (widget._tutorialController
                                .hasFinishedDetailScreenStep)
                              CompletionContainer(
                                completionGoal: widget.habit!.completionGoal,
                                todaysCompletions: _todaysHabitCompletions,
                                key: widget.isTutorialContainer
                                    ? widget
                                        ._tutorialController.completionRowKey
                                    : null,
                              )
                            else
                              const SizedBox(height: 20)
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
              child: widget._tutorialController.hasFinishedDetailScreenStep
                  ? AnimatedCompleteButton(
                      colorTween: _colorTween,
                      pressAnimation: _pressAnimation,
                      onPressed: widget.onPressed,
                      key: widget.isTutorialContainer
                          ? widget._tutorialController.completeButtonKey
                          : null,
                      buttonAnimController: _buttonAnimController,
                    )
                  : const SizedBox.shrink())
        ],
      ),
    );
  }
}

class AnimatedCompleteButton extends StatelessWidget {
  final AnimationController? buttonAnimController;
  final VoidCallback? onPressed;
  final Animation<double>? pressAnimation;
  final Animation<Color?>? colorTween;
  final Key? tutorialKey;

  const AnimatedCompleteButton(
      {Key? key,
      this.buttonAnimController,
      this.onPressed,
      this.pressAnimation,
      this.colorTween,
      this.tutorialKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: buttonAnimController!,
      builder: (BuildContext context, Widget? child) {
        return NeumorphicButton(
          onPressed: onPressed,
          key: tutorialKey,
          style: kInactiveNeumorphStyle.copyWith(
              depth: pressAnimation!.value, color: colorTween!.value),
          padding: EdgeInsets.zero,
          child: const SizedBox(
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
    );
  }
}

class CompletionContainer extends StatelessWidget {
  final int? completionGoal;
  final int? todaysCompletions;

  const CompletionContainer(
      {Key? key, this.completionGoal, this.todaysCompletions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.0,
      width: completionGoal! * 20.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: completionGoal,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
            child: index >= todaysCompletions!
                ? Neumorphic(
                    style: kInactiveNeumorphStyle.copyWith(
                      intensity: 0.9,
                      depth: 2,
                      boxShape: NeumorphicBoxShape.roundRect(
                          const BorderRadius.all(Radius.circular(3))),
                    ),
                    child: const SizedBox(
                      width: 15,
                      height: 15,
                    ),
                  )
                : Neumorphic(
                    style: kActiveNeumorphStyle.copyWith(
                      intensity: 0.9,
                      depth: -2,
                      boxShape: NeumorphicBoxShape.roundRect(
                          const BorderRadius.all(Radius.circular(3))),
                    ),
                    child: const SizedBox(
                      width: 15,
                      height: 15,
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class AllHabitContainer extends StatelessWidget {
  final Habit? habit;

  const AllHabitContainer({
    Key? key,
    this.habit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Hero(
        tag: "all${habit!.id}",
        child: GestureDetector(
          onTap: () {
            Get.to(() => HabitDetailScreen(
                  habit: habit,
                  alterHeroTag: true,
                  isTutorialScreen: false,
                ));
          },
          child: Neumorphic(
            style: kInactiveNeumorphStyle.copyWith(color: kLightOrange),
            child: SizedBox(
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
                        habit!.title!,
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: kBackGroundWhite,
                            ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      height: 30,
                      child: ListView.builder(
                          itemCount: 7,
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: habit!.scheduledWeekDays.contains(index + 1)
                                  ? Neumorphic(
                                      style: kActiveNeumorphStyle.copyWith(
                                          intensity: 0.9,
                                          depth: -2,
                                          boxShape:
                                              NeumorphicBoxShape.roundRect(
                                                  const BorderRadius.all(
                                                      Radius.circular(3)))),
                                      child: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: Center(
                                          child: Text(
                                            dayNames[index],
                                            style: Theme.of(context)
                                                .textTheme
                                                .button!
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
                                          intensity: 0.9,
                                          depth: 2,
                                          boxShape:
                                              NeumorphicBoxShape.roundRect(
                                                  const BorderRadius.all(
                                                      Radius.circular(3)))),
                                      child: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: Center(
                                          child: Text(
                                            dayNames[index],
                                            style: Theme.of(context)
                                                .textTheme
                                                .button!
                                                .copyWith(
                                                  fontSize: 10,
                                                  color: Color(habit!
                                                      .habitColors["deep"]!),
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
