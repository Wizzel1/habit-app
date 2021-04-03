import 'dart:async';
import 'dart:ui';
import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/widgets/widgets.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import 'package:Marbit/screens/createItemScreen.dart';
import 'package:Marbit/util/util.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

const double offset = -0.15;

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;
  final bool alterHeroTag;
  const HabitDetailScreen({Key key, this.habit, this.alterHeroTag})
      : super(key: key);

  @override
  _HabitDetailScreenState createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen>
    with TickerProviderStateMixin {
  bool _isInEditMode = false;
  List<Reward> _joinedRewardList;
  TextEditingController _titleController;
  TextEditingController _descriptionController;

  Animation<Offset> _titleOffset;
  Animation<Offset> _descriptionOffset;
  Animation<Offset> _scheduleOffset;
  Animation<Offset> _goalStepperOffset;
  List<Animation<Offset>> _rewardListOffsets = [];
  AnimationController _editAnimController;

  final Completer _screenBuiltCompleter = Completer();
  final int _mainScreenAnimationDuration = 200;
  final TutorialController _tutorialController = Get.find<TutorialController>();
  final ContentController _contentController = Get.find<ContentController>();

  void _initializeAnimations() {
    _titleOffset = TweenSequence<Offset>([
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0, 0), end: const Offset(0.0, offset)),
          weight: 10.0),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0.0, offset), end: const Offset(0, 0)),
          weight: 20.0),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0.0, 0.0), end: const Offset(0, 0)),
          weight: 70.0)
    ]).animate(
      CurvedAnimation(
        parent: _editAnimController,
        curve: const Interval(
          0.0,
          0.4,
          curve: Curves.ease,
        ),
      ),
    );

    _descriptionOffset = TweenSequence<Offset>([
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0, 0), end: const Offset(0.0, offset)),
          weight: 10.0),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0.0, offset), end: const Offset(0, 0)),
          weight: 20.0),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0.0, 0.0), end: const Offset(0, 0)),
          weight: 70.0)
    ]).animate(
      CurvedAnimation(
        parent: _editAnimController,
        curve: const Interval(
          0.05,
          0.45,
          curve: Curves.ease,
        ),
      ),
    );

    _scheduleOffset = TweenSequence<Offset>([
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0, 0), end: const Offset(0.0, offset)),
          weight: 10.0),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0.0, offset), end: const Offset(0, 0)),
          weight: 20.0),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0.0, 0.0), end: const Offset(0, 0)),
          weight: 70.0)
    ]).animate(
      CurvedAnimation(
        parent: _editAnimController,
        curve: Interval(
          0.1,
          0.5,
          curve: Curves.ease,
        ),
      ),
    );

    // for (var i = 0; i < 7; i++) {
    //   var animation = TweenSequence<Offset>([
    //     TweenSequenceItem(
    //         tween: Tween<Offset>(
    //             begin: const Offset(0, 0), end: const Offset(0.0, -0.15)),
    //         weight: 10.0),
    //     TweenSequenceItem(
    //         tween: Tween<Offset>(
    //             begin: const Offset(0.0, -0.15), end: const Offset(0, 0)),
    //         weight: 10.0),
    //     TweenSequenceItem(
    //         tween: Tween<Offset>(
    //             begin: const Offset(0.0, 0.0), end: const Offset(0, 0)),
    //         weight: 80.0)
    //   ]).animate(
    //     CurvedAnimation(
    //       parent: _editAnimController,
    //       curve: Interval(
    //         0.1 + (i / 25), //max 0.38
    //         0.5 + (i / 25), //max 0.58
    //         curve: Curves.ease,
    //       ),
    //     ),
    //   );
    //   _scheduleOffsets.add(animation);
    // }

    _goalStepperOffset = TweenSequence<Offset>([
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0, 0), end: const Offset(0.0, offset)),
          weight: 10.0),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0.0, offset), end: const Offset(0, 0)),
          weight: 20.0),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0.0, 0.0), end: const Offset(0, 0)),
          weight: 70.0)
    ]).animate(
      CurvedAnimation(
        parent: _editAnimController,
        curve: Interval(
          0.15,
          0.55,
          curve: Curves.ease,
        ),
      ),
    );

    for (var i = 0; i < _contentController.allRewardList.length; i++) {
      var animation = TweenSequence<Offset>([
        TweenSequenceItem(
            tween: Tween<Offset>(
                begin: const Offset(0, 0), end: const Offset(0.0, offset)),
            weight: 10.0),
        TweenSequenceItem(
            tween: Tween<Offset>(
                begin: const Offset(0.0, offset), end: const Offset(0, 0)),
            weight: 20.0),
        TweenSequenceItem(
            tween: Tween<Offset>(
                begin: const Offset(0.0, 0.0), end: const Offset(0, 0)),
            weight: 70.0)
      ]).animate(
        CurvedAnimation(
          parent: _editAnimController,
          curve: Interval(
            0.2 + (i / 25),
            0.6 + (i / 25),
            curve: Curves.ease,
          ),
        ),
      );
      _rewardListOffsets.add(animation);
    }
  }

  @override
  void initState() {
    _setJoinedRewardList();

    _editAnimController = AnimationController(vsync: this);

    _titleController = TextEditingController(text: widget.habit.title);
    _descriptionController =
        TextEditingController(text: widget.habit.description);

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        300.milliseconds.delay().then(
          (value) {
            _screenBuiltCompleter.complete();
            _initializeAnimations();

            (_mainScreenAnimationDuration + 100).milliseconds.delay().then(
              (value) {
                setState(() {});
                //_tutorialController.showDetailScreenTutorial(context);
              },
            );
          },
        );
      },
    );
  }

  void _setJoinedRewardList() {
    List<Reward> _habitRewards = widget.habit.rewardList;
    List<Reward> _allRewards = _contentController.allRewardList;
    List<Reward> _joinedRewards = [];

    _joinedRewards.addAll(_habitRewards);

    for (var i = 0; i < _allRewards.length; i++) {
      Reward _reward = _allRewards[i];
      if (_joinedRewards.any((element) => element.name == _reward.name)) {
        continue;
      }
      _joinedRewards.add(_reward);
    }

    setState(() {
      _joinedRewardList = _joinedRewards;
    });
  }

  Future<void> _playEditingAnimation() async {
    _editAnimController.isAnimating
        ? _editAnimController.reset()
        : _editAnimController.repeat(period: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _editAnimController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.alterHeroTag ? "all${widget.habit.id}" : widget.habit.id,
      child: Scaffold(
        backgroundColor: Color(
          widget.habit.habitColors["light"],
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: FutureBuilder(
          future: _screenBuiltCompleter.future,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return const SizedBox.shrink();
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: AnimationConfiguration.toStaggeredList(
                    duration:
                        Duration(milliseconds: _mainScreenAnimationDuration),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      const SizedBox(height: 30),
                      _buildTitleTextField(),
                      _buildDescriptionTextField(),
                      const SizedBox(height: 30),
                      _buildScheduleRow(),
                      const SizedBox(height: 30),
                      _buildCompletionGoalStepper(),
                      const SizedBox(height: 30),
                      Center(
                        child: _buildEditButton(onPressed: () {
                          if (_isInEditMode) {
                            FocusScope.of(context).unfocus();
                            Get.find<ContentController>().updateHabit(
                                habitID: widget.habit.id,
                                newTitle: _titleController.text,
                                newCompletionGoal: widget.habit.completionGoal,
                                newDescription: _descriptionController.text,
                                newSchedule: widget.habit.scheduledWeekDays,
                                newRewardList: widget.habit.rewardList);
                            _setJoinedRewardList();
                          }
                          _playEditingAnimation();
                        }),
                      ),
                      const SizedBox(height: 30),
                      AnimatedContainer(
                        height: _isInEditMode
                            ? (_contentController.allRewardList.length * 90.0)
                            : (widget.habit.rewardList.length * 90.0),
                        duration: Duration(milliseconds: 800),
                        curve: Curves.easeOutQuint,
                        child: _buildImplicitList(),
                      ),
                      const SizedBox(height: 30),
                      AdController.getLargeBannerAd(context),
                      const SizedBox(height: 30),
                      Center(child: Text("Statistics")),
                      const SizedBox(height: 20),
                      Container(
                        height: 300,
                        child: HabitCompletionChart(
                          habit: widget.habit,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Center(child: _buildHabitDeleteButton()),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTitleTextField() {
    return AnimatedBuilder(
      animation: _titleOffset,
      builder: (context, child) {
        return SlideTransition(
            position: _titleOffset,
            child: Material(
              type: MaterialType.transparency,
              child: IgnorePointer(
                ignoring: !_isInEditMode,
                child: TextField(
                  controller: _titleController,
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(color: kBackGroundWhite),
                  decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: _isInEditMode
                        ? const UnderlineInputBorder(
                            borderSide: BorderSide(color: kBackGroundWhite))
                        : InputBorder.none,
                  ),
                ),
              ),
            ));
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return AnimatedBuilder(
        animation: _descriptionOffset,
        builder: (context, child) {
          return SlideTransition(
              position: _descriptionOffset,
              child: Material(
                type: MaterialType.transparency,
                child: IgnorePointer(
                  ignoring: !_isInEditMode,
                  child: TextField(
                    controller: _descriptionController,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: kBackGroundWhite, fontSize: 22),
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: _isInEditMode
                          ? const UnderlineInputBorder(
                              borderSide: BorderSide(color: kBackGroundWhite))
                          : InputBorder.none,
                    ),
                  ),
                ),
              ));
        });
  }

  Widget _buildCompletionGoalStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _goalStepperOffset,
          builder: (BuildContext context, Widget child) {
            return SlideTransition(
              position: _goalStepperOffset,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _isInEditMode
                    ? MaterialButton(
                        elevation: 0,
                        onPressed: () {
                          if (widget.habit.completionGoal <= 1) return;
                          setState(() {
                            widget.habit.completionGoal--;
                          });
                        },
                        color: kBackGroundWhite,
                        child: Icon(
                          Icons.remove,
                          color: Theme.of(context).accentColor,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      )
                    : const SizedBox.shrink(),
              ),
            );
          },
        ),
        Text(
          "${widget.habit.completionGoal}",
          style: Theme.of(context).textTheme.headline3,
        ),
        AnimatedBuilder(
          animation: _goalStepperOffset,
          builder: (BuildContext context, Widget child) {
            return SlideTransition(
              position: _goalStepperOffset,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _isInEditMode
                    ? MaterialButton(
                        elevation: 0,
                        onPressed: () {
                          if (widget.habit.completionGoal >=
                              ContentController.maxDailyCompletions) return;
                          setState(() {
                            widget.habit.completionGoal++;
                          });
                        },
                        color: kBackGroundWhite,
                        child: Icon(Icons.add,
                            color: Theme.of(context).accentColor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      )
                    : const SizedBox.shrink(),
              ),
            );
          },
        ),
      ],
    );
  }

  MaterialButton _buildEditButton({Function onPressed}) {
    return MaterialButton(
        key: _tutorialController.editButtonKey,
        onPressed: () {
          onPressed();
          setState(() {
            _isInEditMode = !_isInEditMode;
          });
        },
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: kBackGroundWhite,
        child: _isInEditMode
            ? Text(
                "Save Habit",
                style: Theme.of(context).textTheme.button.copyWith(
                      fontSize: 12,
                      color: Color(widget.habit.habitColors["deep"]),
                    ),
              )
            : Text(
                "Edit Habit",
                style: Theme.of(context).textTheme.button.copyWith(
                      fontSize: 12,
                      color: Color(widget.habit.habitColors["deep"]),
                    ),
              ));
  }

  Widget _buildScheduleRow() {
    return AnimatedBuilder(
      animation: _scheduleOffset,
      builder: (BuildContext context, Widget child) {
        return SlideTransition(
          position: _scheduleOffset,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            key: _tutorialController.scheduleRowKey,
            children: List.generate(
              7,
              (index) => GestureDetector(
                onTap: () {
                  if (!_isInEditMode) return;
                  widget.habit.scheduledWeekDays.contains(index + 1)
                      ? widget.habit.scheduledWeekDays.remove(index + 1)
                      : widget.habit.scheduledWeekDays.add(index + 1);
                  setState(() {});
                },
                child: Container(
                  height: 60,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: widget.habit.scheduledWeekDays.contains(index + 1)
                          ? Color(widget.habit.habitColors["deep"])
                          : kBackGroundWhite),
                  child: Center(
                    child: Text(
                      dayNames[index],
                      style: Theme.of(context).textTheme.button.copyWith(
                            fontSize: 12,
                            color: widget.habit.scheduledWeekDays
                                    .contains(index + 1)
                                ? kBackGroundWhite
                                : Color(widget.habit.habitColors["deep"]),
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImplicitList() {
    return ImplicitlyAnimatedList<Reward>(
      physics: NeverScrollableScrollPhysics(),
      key: _tutorialController.rewardListKey,
      shrinkWrap: true,
      removeDuration: const Duration(milliseconds: 200),
      insertDuration: const Duration(milliseconds: 500),
      updateDuration: const Duration(milliseconds: 200),
      items: _joinedRewardList,
      //TODO: this comparison needs to be improved
      areItemsTheSame: (a, b) => a.name == b.name,
      itemBuilder: (context, animation, reward, index) {
        // Specifiy a transition to be used by the ImplicitlyAnimatedList.
        // See the Transitions section on how to import this transition.
        //TODO: this comparison needs to be improved
        bool isSelected = (widget.habit.rewardList
            .any((element) => element.name == reward.name));
        return SizeFadeTransition(
          sizeFraction: 0.7,
          curve: Curves.easeInOut,
          animation: animation,
          child: AnimatedBuilder(
            animation: _rewardListOffsets[index],
            builder: (BuildContext context, Widget child) {
              return SlideTransition(
                position: _rewardListOffsets[index],
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: SelectableRewardContainer(
                    reward: reward,
                    isSelectedReward: isSelected,
                    onTap: () {
                      if (!_isInEditMode) return;
                      setState(() {
                        widget.habit.rewardList.contains(reward)
                            ? widget.habit.rewardList.remove(reward)
                            : widget.habit.rewardList.add(reward);
                      });
                      _setJoinedRewardList();
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  MaterialButton _buildHabitDeleteButton() {
    return MaterialButton(
      onPressed: () {
        Navigator.pop(context);
        Get.find<ContentController>().deleteHabit(widget.habit);
      },
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: kLightRed,
      child: Text(
        "Delete Habit",
        style: Theme.of(context).textTheme.button.copyWith(
              fontSize: 12,
              color: kBackGroundWhite,
            ),
      ),
    );
  }
}
