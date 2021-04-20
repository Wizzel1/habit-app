import 'package:Marbit/util/util.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/services/localStorage.dart';
import 'package:Marbit/util/util.dart';
import 'package:uuid/uuid.dart';

class ContentController extends GetxController {
  static const int maxDailyCompletions = 7;

  static final Habit tutorialHabit = Habit(
      title: 'example_title'.tr,
      id: "testHabit",
      description: 'example_description'.tr,
      scheduledWeekDays: [1, 2, 3, 4, 5],
      rewardIDReferences: [],
      trackedCompletions: DateUtilits.get2021ExampleCompletions(),
      completionGoal: 5);

  List<Reward> allRewardList = [];
  List<Habit> allHabitList = [];
  final RxList<Habit> todaysHabitList = RxList<Habit>();

  void saveNewHabit(Habit habit) {
    assert(habit != null, "Habit must not be null");
    try {
      if (habit.isScheduledForToday()) {
        todaysHabitList.add(habit);
      }
      allHabitList.add(habit);
      LocalStorageService.saveAllHabitsToLocalStorage(allHabitList);
    } catch (e) {
      SnackBars.showErrorSnackBar('error'.tr, "Something went wrong");
    }
  }

  void deleteHabit(Habit habit) {
    assert(habit != null);
    try {
      allHabitList.remove(habit);
      updateHabitList();
      LocalStorageService.saveAllHabitsToLocalStorage(allHabitList);
      reloadHabitList();
      SnackBars.showSuccessSnackBar('success'.tr, 'habit_deleted_message'.tr);
    } on Exception catch (e) {
      SnackBars.showErrorSnackBar('error'.tr, e.toString());
    }
  }

  void saveNewReward(Reward reward) {
    assert(reward != null);
    if (reward == null) return;

    allRewardList.add(reward);
    LocalStorageService.saveAllRewardsToLocalStorage(allRewardList);
  }

  void deleteReward(Reward reward) {
    assert(reward != null);
    try {
      allRewardList.remove(reward);
      updateRewardList();
      LocalStorageService.saveAllRewardsToLocalStorage(allRewardList);
      SnackBars.showSuccessSnackBar('success'.tr, 'reward_deleted_message'.tr);
    } on Exception catch (e) {
      SnackBars.showErrorSnackBar('error'.tr, e.toString());
    }
  }

  List<Reward> getRewardListByID(List<String> rewardIds) {
    assert(rewardIds != null);

    if (rewardIds == null) return [];
    List<Reward> _rewardList = [];

    for (String rewardID in rewardIds) {
      Reward _reward = allRewardList
          .firstWhere((element) => element.id == rewardID, orElse: () => null);
      if (_reward == null) continue;
      _rewardList.add(_reward);
    }
    return _rewardList;
  }

  List<String> filterForDeletedRewards(List<String> rewardReferenceIDs) {
    print("passed in :${rewardReferenceIDs.length} referenceIds");
    List<String> _filteredIDs = [];

    for (String reference in rewardReferenceIDs) {
      Reward reward = allRewardList
          .firstWhere((element) => element.id == reference, orElse: () => null);
      if (reward == null) continue;
      _filteredIDs.add(reward.id);
    }

    print("returning in :${_filteredIDs.length} referenceIds");
    return _filteredIDs;
  }

  @override
  Future<void> onInit() async {
    //LocalStorageService.storageBox.erase();
    await initializeContent();
    super.onInit();
  }

  void _filterAllHabitsForTodaysHabits() {
    for (var i = 0; i < allHabitList.length; i++) {
      Habit _habit = allHabitList[i];
      if (_habit.isScheduledForToday() && !_habit.wasFinishedToday()) {
        todaysHabitList.add(_habit);
      }
    }
  }

  void updateHabitList() {
    update(["allHabitList"]);
  }

  void updateRewardList() {
    update(["allRewardList"]);
  }

  void reloadHabitList() {
    todaysHabitList.clear();
    _filterAllHabitsForTodaysHabits();
  }

  Future<void> initializeContent() async {
    allHabitList = await LocalStorageService.loadHabitsFromLocalStorage();
    allRewardList = await LocalStorageService.loadRewardsFromLocalStorage();

    if (allHabitList.isEmpty) return;
    _filterAllHabitsForTodaysHabits();
  }

  static final List<Reward> exampleRewards = [
    Reward(
      name: 'example_reward_title_1'.tr,
      id: Uuid().v1(),
      description: 'example_reward_description_1'.tr,
    ),
    Reward(
      name: 'example_reward_title_2'.tr,
      id: Uuid().v1(),
      description: 'example_reward_description_2'.tr,
    ),
    Reward(
      name: 'example_reward_title_3'.tr,
      id: Uuid().v1(),
      description: 'example_reward_description_3'.tr,
    ),
    Reward(
      name: 'example_reward_title_4'.tr,
      id: Uuid().v1(),
      description: 'example_reward_description_4'.tr,
    ),
  ];
}
