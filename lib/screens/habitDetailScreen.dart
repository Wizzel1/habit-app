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
import 'package:scroll_to_index/scroll_to_index.dart';

const double offset = -0.15;

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;
  final bool isTutorialScreen;
  final bool alterHeroTag;
  const HabitDetailScreen(
      {Key key, this.habit, this.alterHeroTag, this.isTutorialScreen})
      : super(key: key);

  @override
  _HabitDetailScreenState createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  bool _isInEditMode = false;
  List<Reward> _joinedRewardList;

  final Completer _screenBuiltCompleter = Completer();
  final int _mainScreenAnimationDuration = 200;
  final ContentController _contentController = Get.find<ContentController>();
  final TutorialController _tutorialController = Get.find<TutorialController>();
  final NotificationTimesController _notificationTimesController =
      Get.find<NotificationTimesController>();
  final EditContentController _editContentController =
      Get.find<EditContentController>();

  @override
  void initState() {
    widget.isTutorialScreen ? _setupTutorialScreen() : _setupRegularScreen();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        300.milliseconds.delay().then(
          (value) {
            _screenBuiltCompleter.complete();

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

  void _setupTutorialScreen() {
    _editContentController.loadHabitValues(widget.habit);
    _setJoinedTutorialRewardList();
  }

  void _setupRegularScreen() {
    _filterOutDeletedRewardReferences();
    _editContentController.loadHabitValues(widget.habit);
    _setJoinedRewardList();
    Get.find<AdController>().showInterstitialAd();
  }

  @override
  void dispose() {
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

  void _setJoinedTutorialRewardList() {
    List<String> _selectedRewardIDs =
        _editContentController.cachedRewardReferences;
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

  Widget _buildNextCompletiondateText() {
    return Text("${widget.habit.nextCompletionDate}");
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.alterHeroTag ? "all${widget.habit.id}" : widget.habit.id,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                            //_buildNextCompletiondateText(),
                            const SizedBox(height: 50),
                            _buildCompletionGoalStepper(),
                            const SizedBox(height: 30),
                            _buildScheduledTimesRow(),
                            const SizedBox(height: 50),
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
                                      if (widget.isTutorialScreen) {
                                        _setJoinedTutorialRewardList();
                                        return;
                                      }
                                      _editContentController
                                          .updateHabit(widget.habit.id);
                                      _setJoinedRewardList();
                                    }
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
                                height: widget.isTutorialScreen
                                    ? _isInEditMode
                                        ? (ContentController
                                                .exampleRewards.length *
                                            90.0)
                                        : (_editContentController
                                                .cachedRewardReferences.length *
                                            90.0)
                                    : _isInEditMode
                                        ? (_contentController
                                                .allRewardList.length *
                                            90.0)
                                        : (_editContentController
                                                .cachedRewardReferences.length *
                                            90.0),
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeOutQuint,
                                child: _buildImplicitList(),
                              ),
                            ),
                            widget.isTutorialScreen
                                ? const SizedBox.shrink()
                                : AdController.getLargeBannerAd(context),
                            const SizedBox(height: 50),
                            AutoScrollTag(
                              index: 2,
                              controller: _tutorialController
                                  .tutorialHabitDetailScrollController,
                              key: ValueKey(2),
                              child: Container(
                                height: 300,
                                child: HabitCompletionChart(
                                  key: widget.isTutorialScreen
                                      ? _tutorialController.statisticsElementKey
                                      : null,
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

  Widget _buildCompletionGoalStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _isInEditMode
              ? Neumorphic(
                  style: kInactiveNeumorphStyle,
                  child: GestureDetector(
                    onTap: () {
                      if (!_isInEditMode) return;
                      if (_editContentController.cachedCompletionGoal <= 1)
                        return;
                      _editContentController.cachedCompletionGoal.value--;
                    },
                    onLongPress: () {
                      if (!_isInEditMode) return;
                      _editContentController.cachedCompletionGoal.value = 1;
                    },
                    child: Container(
                      width: 100,
                      height: 40,
                      color: kBackGroundWhite,
                      child: Icon(Icons.remove,
                          color: Theme.of(context).accentColor),
                    ),
                  ),
                )
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
              ? Neumorphic(
                  style: kInactiveNeumorphStyle,
                  child: GestureDetector(
                    onTap: () {
                      if (!_isInEditMode) return;
                      if (_editContentController.cachedCompletionGoal >=
                          ContentController.maxDailyCompletions) return;
                      _editContentController.cachedCompletionGoal.value++;
                    },
                    onLongPress: () {
                      if (!_isInEditMode) return;
                      _editContentController.cachedCompletionGoal.value = 7;
                    },
                    child: Container(
                      width: 100,
                      height: 40,
                      color: kBackGroundWhite,
                      child:
                          Icon(Icons.add, color: Theme.of(context).accentColor),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildEditButton({Function onPressed}) {
    return NeumorphPressSwitch(
      onPressed: () {
        onPressed();
        setState(() {
          _isInEditMode = !_isInEditMode;
        });
      },
      style: _isInEditMode ? kActiveNeumorphStyle : kInactiveNeumorphStyle,
      key: widget.isTutorialScreen ? _tutorialController.editButtonKey : null,
      child: _isInEditMode
          ? Text(
              'save_habit'.tr,
              style: Theme.of(context).textTheme.button.copyWith(
                    fontSize: 12,
                    color: kBackGroundWhite,
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
        key: widget.isTutorialScreen
            ? _tutorialController.notificationTimesKey
            : null,
        spacing: ((MediaQuery.of(context).size.width - 40) - (280)) / 7,
        children: List.generate(
          _editContentController.cachedCompletionGoal.value,
          (index) {
            final bool _isActiveNotification =
                _editContentController.activeNotifications.contains(index + 1);
            return Neumorphic(
              style: _isActiveNotification
                  ? kActiveNeumorphStyle
                  : kInactiveNeumorphStyle,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (!_isInEditMode) return;
                  _editContentController.toggleActiveNotification(index);
                },
                onLongPress: () {
                  if (!_isInEditMode) return;
                  _notificationTimesController.setControllerValues(index);
                  Get.defaultDialog(
                    barrierDismissible: false,
                    content: DialogContent(
                      onPressedSave: () {
                        final bool _saveSuccess = _notificationTimesController
                            .saveSelectedTimeTo(index);
                        if (!_saveSuccess) return;
                        Get.back();
                      },
                    ),
                  );
                },
                child: Container(
                  width: 40,
                  height: 60,
                  color: _isActiveNotification ? kDeepOrange : kBackGroundWhite,
                  child: Center(
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScheduleRow() {
    return Obx(() => Row(
          key: widget.isTutorialScreen
              ? _tutorialController.scheduleRowKey
              : null,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            7,
            (index) {
              final int _weekDayIndex = index + 1;
              final bool _isActiveWeekDay =
                  _editContentController.cachedSchedule.contains(_weekDayIndex);
              return Neumorphic(
                style: _isActiveWeekDay
                    ? kActiveNeumorphStyle
                    : kInactiveNeumorphStyle,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (!_isInEditMode) return;
                    _editContentController.toggleWeekDay(index);
                  },
                  onLongPress: () {
                    if (!_isInEditMode) return;
                    _isActiveWeekDay
                        ? _editContentController.clearSchedule()
                        : _editContentController.fillSchedule();
                  },
                  child: Container(
                    width: 40,
                    height: 60,
                    color: _isActiveWeekDay ? kDeepOrange : kBackGroundWhite,
                    child: Center(
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
                  ),
                ),
              );
            },
          ),
        ));
  }

  Widget _buildImplicitList() {
    return ImplicitlyAnimatedList<Reward>(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      key: widget.isTutorialScreen ? _tutorialController.rewardListKey : null,
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
          child: Obx(() {
            bool isSelected = (_editContentController.cachedRewardReferences
                .any((element) => element == reward.id));
            return SelectableRewardContainer(
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
                widget.isTutorialScreen
                    ? _setJoinedTutorialRewardList()
                    : _setJoinedRewardList();
              },
            );
          }),
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
