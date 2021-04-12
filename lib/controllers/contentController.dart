import 'package:Marbit/util/util.dart';

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
  final RxList todaysHabitList = [].obs;

  void addHabit(Habit habit) {
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

  void updateReward(
      {String rewardID,
      String newTitle,
      String newDescription,
      bool isSelfRemoving}) {
    assert(rewardID != null);
    if (rewardID == null) return;

    int _updateIndex;
    _updateIndex =
        allRewardList.indexWhere((element) => element.id == rewardID);

    assert(_updateIndex != null);
    assert(_updateIndex >= 0, "updateindex must not be negative");

    if (newTitle != null) allRewardList[_updateIndex].name = newTitle;
    if (newDescription != null)
      allRewardList[_updateIndex].description = newDescription;
    if (isSelfRemoving != null)
      allRewardList[_updateIndex].isSelfRemoving = isSelfRemoving;
    LocalStorageService.saveAllRewardsToLocalStorage(allRewardList);
    update(["allRewardList"]);
  }

  bool isValidOrShowSnackbar(dynamic dynamicData) {
    //TODO prevent data saving

    if (dynamicData is String) {
      dynamicData = dynamicData as String;
      if (dynamicData.isEmpty)
        SnackBars.showWarningSnackBar(
            'empty_field_warning_title'.tr, 'empty_field_warning_message'.tr);
      return true;
    }

    if (dynamicData is List<int>) {
      dynamicData = dynamicData as List<int>;
      if (dynamicData.isEmpty) {
        SnackBars.showWarningSnackBar('empty_schedule_warning_title'.tr,
            'empty_schedule_warning_message'.tr);
        return true;
      }
    }

    if (dynamicData is List<Reward>) {
      dynamicData = dynamicData as List<Reward>;
      if (dynamicData.isEmpty) {
        SnackBars.showWarningSnackBar(
            'no_rewards_warning_title'.tr, 'no_rewards_warning_message'.tr);
        return true;
      }
    }

    return false;
  }

  List<Reward> getRewardListByID(List<String> rewardIds) {
    assert(rewardIds != null);

    if (rewardIds == null) return [];
    List<Reward> _rewardList = [];

    for (String rewardID in rewardIds) {
      Reward _reward =
          allRewardList.firstWhere((element) => element.id == rewardID);
      _rewardList.add(_reward);
    }
    return _rewardList;
  }

  void updateHabit(
      {String habitID,
      String newTitle,
      String newDescription,
      int newCompletionGoal,
      List<int> newSchedule,
      List<String> newRewardReferences}) {
    assert(habitID != null);

    if (habitID == null) return;

    int _updateIndex;
    _updateIndex = allHabitList.indexWhere((element) => element.id == habitID);

    assert(_updateIndex != null);
    assert(_updateIndex >= 0, "updateindex must not be negative");

    newSchedule?.sort();

    if (isValidOrShowSnackbar(newTitle))
      allHabitList[_updateIndex].title = newTitle;
    if (isValidOrShowSnackbar(newSchedule))
      allHabitList[_updateIndex].scheduledWeekDays = newSchedule;
    if (isValidOrShowSnackbar(newRewardReferences))
      allHabitList[_updateIndex].rewardIDReferences = newRewardReferences;

    if (newDescription != null)
      allHabitList[_updateIndex].description = newDescription;
    if (newCompletionGoal != null)
      allHabitList[_updateIndex].completionGoal = newCompletionGoal;

    LocalStorageService.saveAllHabitsToLocalStorage(allHabitList);
    update(["allHabitList"]);
    _reloadHabitList();
  }

  void deleteHabit(Habit habit) {
    assert(habit != null);
    try {
      allHabitList.remove(habit);
      update(["allHabitList"]);
      LocalStorageService.saveAllHabitsToLocalStorage(allHabitList);
      _reloadHabitList();
      SnackBars.showSuccessSnackBar('success'.tr, 'habit_deleted_message'.tr);
    } on Exception catch (e) {
      SnackBars.showErrorSnackBar('error'.tr, e.toString());
    }
  }

  void deleteReward(Reward reward) {
    assert(reward != null);
    try {
      allRewardList.remove(reward);
      update(["allRewardList"]);
      LocalStorageService.saveAllRewardsToLocalStorage(allRewardList);
      SnackBars.showSuccessSnackBar('success'.tr, 'reward_deleted_message'.tr);
    } on Exception catch (e) {
      SnackBars.showErrorSnackBar('error'.tr, e.toString());
    }
  }

  @override
  void onInit() {
    //LocalStorageService.storageBox.erase();
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

  void _reloadHabitList() {
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

  void addReward(Reward reward) {
    assert(reward != null);
    if (reward == null) return;

    allRewardList.add(reward);
    LocalStorageService.saveAllRewardsToLocalStorage(allRewardList);
  }
}
