import 'dart:async';
import 'dart:ui';
import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
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
    _testController.dispose();
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
        _editContentController.cachedRewardReferences;
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
    _testController.isAnimating
        ? _testController.reset()
        : _testController.repeat(period: const Duration(seconds: 2));
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
                      _buildTitleTextField(),
                      const SizedBox(height: 50),
                      _buildScheduleRow(),
                      //_buildNextCompletiondateText(),
                      const SizedBox(height: 50),
                      //_buildChangeActiveNotificationButtons(),
                      _buildCompletionGoalStepper(),
                      const SizedBox(height: 30),
                      _buildScheduledTimesRow(),
                      const SizedBox(height: 50),
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
                      const SizedBox(height: 50),
                      AnimatedContainer(
                        height: _isInEditMode
                            ? (_contentController.allRewardList.length * 90.0)
                            : (_editContentController
                                    .cachedRewardReferences.length *
                                90.0),
                        duration: Duration(milliseconds: 800),
                        curve: Curves.easeOutQuint,
                        child: _buildImplicitList(),
                      ),
                      AdController.getLargeBannerAd(context),
                      const SizedBox(height: 50),
                      Container(
                        height: 300,
                        child: HabitCompletionChart(
                          habit: widget.habit,
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
                        if (_editContentController.cachedCompletionGoal <= 1)
                          return;
                        _editContentController.cachedCompletionGoal.value--;
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
                    "${_editContentController.cachedCompletionGoal}",
                    style: Theme.of(context).textTheme.headline3.copyWith(),
                    textAlign: TextAlign.center,
                  )),
              Text(
                'per_day'.tr,
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
                        if (_editContentController.cachedCompletionGoal >=
                            ContentController.maxDailyCompletions) return;
                        _editContentController.cachedCompletionGoal.value++;
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
      child: _isInEditMode
          ? Text(
              'save_habit'.tr,
              style: Theme.of(context).textTheme.button.copyWith(
                    fontSize: 12,
                    color: kDeepOrange,
                  ),
            )
          : Text(
              'edit_habit'.tr,
              style: Theme.of(context).textTheme.button.copyWith(
                    fontSize: 12,
                    color: kDeepOrange,
                  ),
            ),
    );
  }

  Widget _buildScheduledTimesRow() {
    return Obx(
      () => Wrap(
        spacing: ((MediaQuery.of(context).size.width - 40) - (280)) / 7,
        children: List.generate(
          _editContentController.cachedCompletionGoal.value,
          (index) => AnimatedBuilder(
            animation: _testController,
            builder: (BuildContext context, Widget child) {
              bool _isActiveNotification = _editContentController
                  .activeNotifications
                  .contains(index + 1);
              return ScaleTransition(
                scale: _positiveScaleAnimation,
                child: NeumorphPressSwitch(
                  width: 40,
                  height: 60,
                  style: _isActiveNotification
                      ? kActiveNeumorphStyle.copyWith(
                          depth: _negativeDepthAnmation.value)
                      : kInactiveNeumorphStyle.copyWith(
                          depth: _positiveDepthAnimation.value),
                  onPressed: () {
                    if (!_isInEditMode) return;
                    _isActiveNotification
                        ? _editContentController.activeNotifications
                            .remove(index + 1)
                        : _editContentController.activeNotifications
                            .add(index + 1);
                  },
                  onLongPressed: () {
                    if (!_isInEditMode) return;
                    _notificationTimesController.setControllerValues(index);
                    Get.defaultDialog(
                      barrierDismissible: false,
                      content: DialogContent(index: index),
                    );
                  },
                  child: Obx(
                    () => Text(
                        "${_notificationTimesController.selectedHours[index]}\n${_notificationTimesController.selectedMinutes[index].toString().padLeft(2, "0")}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.button.copyWith(
                            color: _isActiveNotification
                                ? kBackGroundWhite
                                : kDeepOrange)),
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
                bool _isActiveWeekDay = _editContentController.cachedSchedule
                    .contains(_weekDayIndex);
                return ScaleTransition(
                  scale: _isActiveWeekDay
                      ? _negativeScaleAnimation
                      : _positiveScaleAnimation,
                  child: NeumorphPressSwitch(
                    onPressed: () {
                      if (!_isInEditMode) return;
                      if (_isActiveWeekDay) {
                        _editContentController.cachedSchedule
                            .remove(_weekDayIndex);
                      } else {
                        _editContentController.cachedSchedule
                            .add(_weekDayIndex);
                      }
                      _editContentController.cachedSchedule.sort();
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
      physics: const NeverScrollableScrollPhysics(),
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
              bool isSelected = (_editContentController.cachedRewardReferences
                  .any((element) => element == reward.id));
              return ScaleTransition(
                scale: isSelected
                    ? _negativeScaleAnimation
                    : _positiveScaleAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: SelectableRewardContainer(
                    reward: reward,
                    isSelectedReward: isSelected,
                    onTap: () {
                      if (!_isInEditMode) return;
                      _editContentController.cachedRewardReferences
                              .contains(reward.id)
                          ? _editContentController.cachedRewardReferences
                              .remove(reward.id)
                          : _editContentController.cachedRewardReferences
                              .add(reward.id);
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

  Widget _buildHabitDeleteButton() {
    return CustomNeumorphButton(
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
