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
import 'package:scroll_to_index/scroll_to_index.dart';

const double offset = -0.15;

class TutorialHabitDetailScreen extends StatefulWidget {
  final Habit habit;
  const TutorialHabitDetailScreen({Key key, this.habit}) : super(key: key);

  @override
  _TutorialHabitDetailScreenState createState() =>
      _TutorialHabitDetailScreenState();
}

class _TutorialHabitDetailScreenState extends State<TutorialHabitDetailScreen>
    with TickerProviderStateMixin {
  static const double _maxDepth = 4.0;
  static const double _maxScale = 1.02;

  bool _isInEditMode = false;
  List<Reward> _joinedRewardList;

  AnimationController _testController;
  Animation<double> _positiveDepthAnimation;
  Animation<double> _negativeDepthAnmation;
  Animation<double> _positiveScaleAnimation;
  Animation<double> _negativeScaleAnimation;

  final Completer _screenBuiltCompleter = Completer();
  final int _mainScreenAnimationDuration = 200;
  final TutorialController _tutorialController = Get.find<TutorialController>();
  final ContentController _contentController = Get.find<ContentController>();
  final NotificationTimesController _notificationTimesController =
      Get.find<NotificationTimesController>();
  final EditContentController _editContentController =
      Get.find<EditContentController>();

  void _initializeAnimations() {
    _positiveDepthAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 2.0, end: _maxDepth), weight: 1.0),
      TweenSequenceItem(
          tween: Tween<double>(begin: _maxDepth, end: 2.0), weight: 1.0)
    ]).animate(CurvedAnimation(
      parent: _testController,
      curve: const Interval(
        0.0,
        0.4,
        curve: Curves.ease,
      ),
    ));
    _negativeDepthAnmation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: -2.0, end: -_maxDepth), weight: 1.0),
      TweenSequenceItem(
          tween: Tween<double>(begin: -_maxDepth, end: -2.0), weight: 1.0)
    ]).animate(CurvedAnimation(
      parent: _testController,
      curve: const Interval(
        0.0,
        0.4,
        curve: Curves.ease,
      ),
    ));
    _positiveScaleAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: _maxScale), weight: 1.0),
      TweenSequenceItem(
          tween: Tween<double>(begin: _maxScale, end: 1.0), weight: 1.0),
    ]).animate(CurvedAnimation(
      parent: _testController,
      curve: const Interval(
        0.0,
        0.4,
        curve: Curves.ease,
      ),
    ));

    _negativeScaleAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 1.0), weight: 1.0),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 1.0), weight: 1.0),
    ]).animate(CurvedAnimation(
      parent: _testController,
      curve: const Interval(
        0.0,
        0.4,
        curve: Curves.ease,
      ),
    ));
  }

  @override
  void initState() {
    _testController = AnimationController(vsync: this);

    _editContentController.loadHabitValues(widget.habit);

    _setJoinedTutorialRewardList();

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        300.milliseconds.delay().then(
          (value) {
            _screenBuiltCompleter.complete();
            _initializeAnimations();

            (_mainScreenAnimationDuration + 100).milliseconds.delay().then(
              (value) {
                _tutorialController.resumeToLatestTutorialStep(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _testController.dispose();
    Get.delete<EditContentController>();
    super.dispose();
  }

  void _setJoinedTutorialRewardList() {
    List<String> _selectedRewardIDs =
        _editContentController.newRewardReferences;
    List<Reward> _selectedRewards =
        _contentController.getTutorialRewardListByID(_selectedRewardIDs);
    List<Reward> _exampleRewards = ContentController.exampleRewards;
    List<Reward> _joinedRewards = [];
    _joinedRewards.addAll(_selectedRewards);

    for (var i = 0; i < _exampleRewards.length; i++) {
      Reward _reward = _exampleRewards[i];
      if (_joinedRewards.any((element) => element.id == _reward.id)) {
        continue;
      }
      _joinedRewards.add(_reward);
    }

    setState(() {
      _joinedRewardList = _joinedRewards;
    });
  }

  Future<void> _toggleEditingAnimation() async {
    _testController.isAnimating
        ? _testController.reset()
        : _testController.repeat(period: const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.habit.id,
      child: GetBuilder(
        id: TutorialController.habitDetailBuilderID,
        builder: (TutorialController controller) {
          return IgnorePointer(
            ignoring: !_tutorialController.hasFinishedDetailScreenStep,
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
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return const SizedBox.shrink();
                  return SingleChildScrollView(
                    controller:
                        _tutorialController.tutorialHabitDetailScrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: AnimationConfiguration.toStaggeredList(
                          duration: Duration(
                              milliseconds: _mainScreenAnimationDuration),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: [
                            _buildTitleTextField(),
                            const SizedBox(height: 50),
                            _buildScheduleRow(),
                            const SizedBox(height: 50),
                            _buildCompletionGoalStepper(),
                            const SizedBox(height: 30),
                            _buildScheduledTimesRow(),
                            const SizedBox(height: 30),
                            Center(
                              child: AutoScrollTag(
                                index: 3,
                                controller: _tutorialController
                                    .tutorialHabitDetailScrollController,
                                key: ValueKey(3),
                                child: _buildEditButton(
                                  onPressed: () {
                                    if (_isInEditMode) {
                                      FocusScope.of(context).unfocus();
                                      _setJoinedTutorialRewardList();
                                    }
                                    _toggleEditingAnimation();
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            AutoScrollTag(
                              index: 1,
                              controller: _tutorialController
                                  .tutorialHabitDetailScrollController,
                              key: ValueKey(1),
                              child: AnimatedContainer(
                                height: _isInEditMode
                                    ? (ContentController.exampleRewards.length *
                                        90.0)
                                    : (_editContentController
                                            .newRewardReferences.length *
                                        90.0),
                                duration: Duration(milliseconds: 800),
                                curve: Curves.easeOutQuint,
                                child: _buildImplicitList(),
                              ),
                            ),
                            const SizedBox(height: 50),
                            AutoScrollTag(
                              index: 2,
                              controller: _tutorialController
                                  .tutorialHabitDetailScrollController,
                              key: ValueKey(2),
                              child: Container(
                                height: 300,
                                child: HabitCompletionChart(
                                  key: _tutorialController.statisticsElementKey,
                                  habit: widget.habit,
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            Center(child: _buildHabitDeleteButton()),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitleTextField() {
    return GetBuilder<EditContentController>(
      builder: (EditContentController controller) {
        return Material(
          type: MaterialType.transparency,
          child: IgnorePointer(
            ignoring: !_isInEditMode,
            child: TextField(
              controller: controller.titleController,
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
        );
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return GetBuilder<EditContentController>(
      builder: (EditContentController controller) {
        return Material(
          type: MaterialType.transparency,
          child: IgnorePointer(
            ignoring: !_isInEditMode,
            child: TextField(
              controller: controller.descriptionController,
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
        );
      },
    );
  }

  Widget _buildCompletionGoalStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _isInEditMode
              ? AnimatedBuilder(
                  animation: _positiveDepthAnimation,
                  builder: (BuildContext context, Widget child) {
                    return CustomNeumorphButton(
                      onPressed: () {
                        if (_editContentController.newCompletionGoal <= 1)
                          return;
                        _editContentController.newCompletionGoal.value--;
                      },
                      style: kInactiveNeumorphStyle.copyWith(
                          depth: _positiveDepthAnimation.value),
                      child: Icon(Icons.remove,
                          color: Theme.of(context).accentColor),
                    );
                  })
              : const SizedBox.shrink(),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Obx(() => Text(
                    "${_editContentController.newCompletionGoal}",
                    style: Theme.of(context).textTheme.headline3.copyWith(),
                    textAlign: TextAlign.center,
                  )),
              //TODO translate
              Text(
                "per Day",
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _isInEditMode
              ? AnimatedBuilder(
                  animation: _positiveDepthAnimation,
                  builder: (BuildContext context, Widget child) {
                    return CustomNeumorphButton(
                      onPressed: () {
                        if (_editContentController.newCompletionGoal >=
                            ContentController.maxDailyCompletions) return;
                        _editContentController.newCompletionGoal.value++;
                      },
                      style: kInactiveNeumorphStyle.copyWith(
                          depth: _positiveDepthAnimation.value),
                      child:
                          Icon(Icons.add, color: Theme.of(context).accentColor),
                    );
                  })
              : const SizedBox.shrink(),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildEditButton({Function onPressed}) {
    return CustomNeumorphButton(
      onPressed: () {
        onPressed();
        setState(() {
          _isInEditMode = !_isInEditMode;
        });
      },
      key: _tutorialController.editButtonKey,
      child: _isInEditMode
          ? Text(
              'save_habit'.tr,
              style: Theme.of(context).textTheme.button.copyWith(
                    fontSize: 12,
                    color: Color(widget.habit.habitColors["deep"]),
                  ),
            )
          : Text(
              'edit_habit'.tr,
              style: Theme.of(context).textTheme.button.copyWith(
                    fontSize: 12,
                    color: Color(widget.habit.habitColors["deep"]),
                  ),
            ),
    );
  }

  Widget _buildScheduledTimesRow() {
    return Obx(
      () => Wrap(
        key: _tutorialController.scheduleRowKey,
        spacing: ((MediaQuery.of(context).size.width - 40) - (280)) / 7,
        children: List.generate(
          _editContentController.newCompletionGoal.value,
          (index) => AnimatedBuilder(
            animation: _testController,
            builder: (BuildContext context, Widget child) {
              return ScaleTransition(
                scale: _positiveScaleAnimation,
                child: CustomNeumorphButton(
                  width: 40,
                  height: 60,
                  style: kInactiveNeumorphStyle.copyWith(
                      depth: _positiveDepthAnimation.value),
                  onPressed: () async {
                    if (!_isInEditMode) return;
                    _notificationTimesController.setControllerValues(index);
                    Get.defaultDialog(
                      barrierDismissible: false,
                      content: DialogContent(index: index),
                    );
                  },
                  child: Obx(
                    () => Text(
                        "${_notificationTimesController.selectedHours[index]} \n${_notificationTimesController.selectedMinutes[index].toString().padLeft(2, "0")}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: kDeepOrange)),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleRow() {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            7,
            (index) => AnimatedBuilder(
              animation: _positiveDepthAnimation,
              builder: (BuildContext context, Widget child) {
                int _weekDayIndex = index + 1;
                bool _isActiveWeekDay =
                    _editContentController.newSchedule.contains(_weekDayIndex);
                return ScaleTransition(
                  scale: _isActiveWeekDay
                      ? _negativeScaleAnimation
                      : _positiveScaleAnimation,
                  child: NeumorphPressSwitch(
                    onPressed: () {
                      if (!_isInEditMode) return;
                      if (_isActiveWeekDay) {
                        _editContentController.newSchedule
                            .remove(_weekDayIndex);
                      } else {
                        _editContentController.newSchedule.add(_weekDayIndex);
                      }
                      _editContentController.newSchedule.sort();
                    },
                    height: 60,
                    width: 40,
                    style: _isActiveWeekDay
                        ? kActiveNeumorphStyle.copyWith(
                            depth: _negativeDepthAnmation.value)
                        : kInactiveNeumorphStyle.copyWith(
                            depth: _positiveDepthAnimation.value),
                    child: Text(
                      dayNames[index],
                      style: Theme.of(context).textTheme.button.copyWith(
                            fontSize: 12,
                            color: _isActiveWeekDay
                                ? kBackGroundWhite
                                : Color(widget.habit.habitColors["deep"]),
                          ),
                    ),
                  ),
                );
              },
            ),
          ),
        ));
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
      areItemsTheSame: (a, b) => a.id == b.id,
      itemBuilder: (context, animation, reward, index) {
        // Specifiy a transition to be used by the ImplicitlyAnimatedList.
        // See the Transitions section on how to import this transition.

        return SizeFadeTransition(
          sizeFraction: 0.7,
          curve: Curves.easeInOut,
          animation: animation,
          child: AnimatedBuilder(
            animation: _testController,
            builder: (BuildContext context, Widget child) {
              bool isSelected = (_editContentController.newRewardReferences
                  .any((element) => element == reward.id));
              return ScaleTransition(
                scale: isSelected
                    ? _negativeScaleAnimation
                    : _positiveScaleAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Obx(
                    () {
                      return SelectableRewardContainer(
                        reward: reward,
                        isSelectedReward: isSelected,
                        onTap: () {
                          if (!_isInEditMode) return;
                          _editContentController.newRewardReferences
                                  .contains(reward.id)
                              ? _editContentController.newRewardReferences
                                  .remove(reward.id)
                              : _editContentController.newRewardReferences
                                  .add(reward.id);
                          _setJoinedTutorialRewardList();
                        },
                      );
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

  Widget _buildHabitDeleteButton() {
    //TODO add tutorial key
    return NeumorphPressSwitch(
      onPressed: () {},
      style: kInactiveNeumorphStyle.copyWith(color: kLightRed),
      child: Text(
        'delete_habit'.tr,
        style: Theme.of(context).textTheme.button.copyWith(
              fontSize: 12,
              color: kBackGroundWhite,
            ),
      ),
    );
  }
}
