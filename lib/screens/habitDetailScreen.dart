import 'dart:async';
import 'dart:ui';
import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:Marbit/screens/screens.dart';
import 'package:Marbit/util/util.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';

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

  Animation<Offset> _titleOffset;
  Animation<Offset> _descriptionOffset;
  Animation<Offset> _scheduleOffset;
  Animation<Offset> _goalStepperOffset;
  List<Animation<Offset>> _rewardListOffsets = [];
  AnimationController _editAnimController;

  final Completer _screenBuiltCompleter = Completer();
  final int _mainScreenAnimationDuration = 200;
  final ContentController _contentController = Get.find<ContentController>();
  final NotificationTimesController _notificationTimesController =
      Get.find<NotificationTimesController>();
  final EditContentController _editContentController =
      Get.find<EditContentController>();

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
    _editAnimController = AnimationController(vsync: this);
    _filterOutDeletedRewardReferences();
    _editContentController.loadHabitValues(widget.habit);
    _setJoinedRewardList();
    Get.find<AdController>().showInterstitialAd();
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
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _editAnimController.dispose();
    Get.delete<NotificationTimesController>();
    Get.delete<EditContentController>();
    super.dispose();
  }

  //TODO maybe this should take effect when a reward is delted?
  void _filterOutDeletedRewardReferences() {
    widget.habit.rewardIDReferences = _contentController
        .filterForDeletedRewards(widget.habit.rewardIDReferences);
  }

  //TODO move this method to contentcontroller
  void _setJoinedRewardList() {
    List<String> _selectedRewardIDs =
        _editContentController.newRewardReferences;
    List<Reward> _selectedRewards =
        _contentController.getRewardListByID(_selectedRewardIDs);
    List<Reward> _allRewards = _contentController.allRewardList;
    List<Reward> _joinedRewards = [];
    _joinedRewards.addAll(_selectedRewards);

    for (var i = 0; i < _allRewards.length; i++) {
      Reward _reward = _allRewards[i];
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
    _editAnimController.isAnimating
        ? _editAnimController.reset()
        : _editAnimController.repeat(period: const Duration(seconds: 3));
  }

  Widget _buildNextCompletiondateText() {
    return Text("${widget.habit.nextCompletionDate}");
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      //_buildNextCompletiondateText(),
                      const SizedBox(height: 30),
                      _buildCompletionGoalStepper(),
                      _buildScheduledTimesWrapper(),
                      const SizedBox(height: 30),
                      Center(
                        child: _buildEditButton(
                          onPressed: () {
                            if (_isInEditMode) {
                              FocusScope.of(context).unfocus();

                              _editContentController
                                  .updateHabit(widget.habit.id);

                              _setJoinedRewardList();
                            }
                            _toggleEditingAnimation();
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      AnimatedContainer(
                        height: _isInEditMode
                            ? (_contentController.allRewardList.length * 90.0)
                            : (_editContentController
                                    .newRewardReferences.length *
                                90.0),
                        duration: Duration(milliseconds: 800),
                        curve: Curves.easeOutQuint,
                        child: _buildImplicitList(),
                      ),
                      AdController.getLargeBannerAd(context),
                      const SizedBox(height: 30),
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
    return GetBuilder<EditContentController>(
      builder: (EditContentController controller) {
        return AnimatedBuilder(
          animation: _titleOffset,
          builder: (context, child) {
            return SlideTransition(
              position: _titleOffset,
              child: child,
            );
          },
          child: Material(
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
          ),
        );
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return GetBuilder<EditContentController>(
      builder: (EditContentController controller) {
        return AnimatedBuilder(
          animation: _descriptionOffset,
          builder: (context, child) {
            return SlideTransition(
              position: _descriptionOffset,
              child: child,
            );
          },
          child: Material(
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
        AnimatedBuilder(
          animation: _goalStepperOffset,
          builder: (BuildContext context, Widget child) {
            return SlideTransition(
              position: _goalStepperOffset,
              child: child,
            );
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _isInEditMode
                ? NeumorphPressSwitch(
                    onPressed: () {
                      if (_editContentController.newCompletionGoal <= 1) return;
                      _editContentController.newCompletionGoal.value--;
                    },
                    child: Icon(
                      Icons.remove,
                      color: Theme.of(context).accentColor,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
        Expanded(
          flex: 2,
          child: Obx(() => Text(
                "${_editContentController.newCompletionGoal}",
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              )),
        ),
        AnimatedBuilder(
          animation: _goalStepperOffset,
          builder: (BuildContext context, Widget child) {
            return SlideTransition(
              position: _goalStepperOffset,
              child: child,
            );
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _isInEditMode
                ? NeumorphPressSwitch(
                    onPressed: () {
                      if (_editContentController.newCompletionGoal >=
                          ContentController.maxDailyCompletions) return;
                      _editContentController.newCompletionGoal.value++;
                    },
                    child:
                        Icon(Icons.add, color: Theme.of(context).accentColor),
                  )
                : const SizedBox.shrink(),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildEditButton({Function onPressed}) {
    return TestButton(
      onPressed: () {
        onPressed();
        setState(() {
          _isInEditMode = !_isInEditMode;
        });
      },
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

  Widget _buildScheduledTimesWrapper() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 800),
      switchInCurve: Curves.easeOutQuint,
      switchOutCurve: Curves.easeOutQuint,
      child: _isInEditMode
          ? Obx(
              () => ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _editContentController.newCompletionGoal.value,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Spacer(),
                        NeumorphPressSwitch(
                          onPressed: () {
                            _notificationTimesController
                                .subtract30MinutesFromIndex(index);
                          },
                          child: Text("-30",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: kDeepOrange)),
                        ),
                        Expanded(
                          flex: 6,
                          child: Obx(
                            () => Text(
                                "${_notificationTimesController.selectedHours[index]}:${_notificationTimesController.selectedMinutes[index].toString().padLeft(2, "0")}",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline4),
                          ),
                        ),
                        NeumorphPressSwitch(
                          onPressed: () {
                            _notificationTimesController
                                .add30MinutesToIndex(index);
                          },
                          child: Text("+30",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: kDeepOrange)),
                        ),
                        const Spacer(),
                      ],
                    ),
                  );
                },
              ),
            )
          : Obx(
              () => Wrap(
                children: [
                  ...List.generate(
                    _editContentController.newCompletionGoal.value,
                    (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(
                        () => Text(
                          "${_notificationTimesController.selectedHours[index]}:${_notificationTimesController.selectedMinutes[index].toString().padLeft(2, "0")}",
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: kBackGroundWhite),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildScheduleRow() {
    return Obx(() => AnimatedBuilder(
          animation: _scheduleOffset,
          builder: (BuildContext context, Widget child) {
            return SlideTransition(
              position: _scheduleOffset,
              child: child,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              7,
              (index) => NeumorphPressSwitch(
                onPressed: () {
                  if (!_isInEditMode) return;
                  int weekDayIndex = index + 1;
                  if (_editContentController.newSchedule
                      .contains(weekDayIndex)) {
                    _editContentController.newSchedule.remove(weekDayIndex);
                  } else {
                    _editContentController.newSchedule.add(weekDayIndex);
                  }
                  _editContentController.newSchedule.sort();
                },
                height: 60,
                width: 40,
                color: _editContentController.newSchedule.contains(index + 1)
                    ? Color(widget.habit.habitColors["deep"])
                    : kBackGroundWhite,
                inPressedState:
                    _editContentController.newSchedule.contains(index + 1),
                child: Text(
                  dayNames[index],
                  style: Theme.of(context).textTheme.button.copyWith(
                        fontSize: 12,
                        color: _editContentController.newSchedule
                                .contains(index + 1)
                            ? kBackGroundWhite
                            : Color(widget.habit.habitColors["deep"]),
                      ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildImplicitList() {
    return ImplicitlyAnimatedList<Reward>(
      physics: NeverScrollableScrollPhysics(),
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
            animation: _rewardListOffsets[index],
            builder: (BuildContext context, Widget child) {
              return SlideTransition(
                position: _rewardListOffsets[index],
                child: child,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Obx(
                () {
                  bool isSelected = (_editContentController.newRewardReferences
                      .any((element) => element == reward.id));
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
                      _setJoinedRewardList();
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHabitDeleteButton() {
    return NeumorphPressSwitch(
      onPressed: () {
        Get.back();
        Get.find<ContentController>().deleteHabit(widget.habit);
      },
      color: kLightRed,
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
