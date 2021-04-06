import 'package:Marbit/util/util.dart';

import 'package:get/get.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/services/localStorage.dart';
import 'package:Marbit/util/util.dart';
import 'package:uuid/uuid.dart';

class ContentController extends GetxController {
  static const int maxDailyCompletions = 7;

  static final Habit tutorialHabit = Habit(
      title: "Example",
      id: "testHabit",
      description: "This is an example Habit.",
      scheduledWeekDays: [1, 2, 3, 4, 5],
      rewardIDReferences: [],
      trackedCompletions: DateUtilits.get2021ExampleCompletions(),
      completionGoal: 5);

  List<Reward> allRewardList = [];
  List<Habit> allHabitList = [];
  final RxList todaysHabitList = [].obs;

  void addHabit(Habit habit) {
    if (habit.isScheduledForToday()) {
      todaysHabitList.add(habit);
    }
    allHabitList.add(habit);
    LocalStorageService.saveAllHabitsToLocalStorage(allHabitList);
  }

  void updateReward(
      {String rewardID,
      String newTitle,
      String newDescription,
      bool isSelfRemoving}) {
    int _updateIndex;
    if (rewardID != null) {
      _updateIndex =
          allRewardList.indexWhere((element) => element.id == rewardID);
    }

    if (newTitle != null) allRewardList[_updateIndex].name = newTitle;
    if (newDescription != null)
      allRewardList[_updateIndex].description = newDescription;
    if (isSelfRemoving != null)
      allRewardList[_updateIndex].isSelfRemoving = isSelfRemoving;
    LocalStorageService.saveAllRewardsToLocalStorage(allRewardList);
    update(["allRewardList"]);
  }

  bool isValid(dynamic dynamicData) {
    if (dynamicData == null) return false;

    if (dynamicData is String) {
      dynamicData = dynamicData as String;
      if (dynamicData.isEmpty)
        SnackBars.showWarningSnackBar(
            "Empty Field", "You saved an empty Field");
      return true;
    }

    if (dynamicData is List<int>) {
      dynamicData = dynamicData as List<int>;
      if (dynamicData.isEmpty) {
        SnackBars.showWarningSnackBar(
            "Empty Schedule", "You saved an empty Schedule");
        return true;
      }
    }

    if (dynamicData is List<Reward>) {
      dynamicData = dynamicData as List<Reward>;
      if (dynamicData.isEmpty) {
        SnackBars.showWarningSnackBar(
            "No Rewards", "You have no saved Rewards");
        return true;
      }
    }

    return false;
  }

  List<Reward> getRewardListByID(List<String> rewardIds) {
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
    int _updateIndex;

    if (habitID != null) {
      _updateIndex =
          allHabitList.indexWhere((element) => element.id == habitID);
    }

    newSchedule?.sort();

    if (isValid(newTitle)) allHabitList[_updateIndex].title = newTitle;
    if (isValid(newSchedule))
      allHabitList[_updateIndex].scheduledWeekDays = newSchedule;
    if (isValid(newRewardReferences))
      allHabitList[_updateIndex].rewardIDReferences = newRewardReferences;

    // if (newTitle != null) allHabitList[_updateIndex].name = newTitle;
    if (newDescription != null)
      allHabitList[_updateIndex].description = newDescription;
    // if (newSchedule != null)
    //   allHabitList[_updateIndex].scheduledWeekDays = newSchedule;
    // if (newRewardList != null)
    //   allHabitList[_updateIndex].rewardList = newRewardList;
    if (newCompletionGoal != null)
      allHabitList[_updateIndex].completionGoal = newCompletionGoal;

    LocalStorageService.saveAllHabitsToLocalStorage(allHabitList);
    update(["allHabitList"]);
    _reloadHabitList();
  }

  void deleteHabit(Habit habit) {
    //TODO: probably needs improvement
    try {
      allHabitList.remove(habit);
      update(["allHabitList"]);
      LocalStorageService.saveAllHabitsToLocalStorage(allHabitList);
      _reloadHabitList();
      SnackBars.showSuccessSnackBar("Success", "The Habit has been deleted");
    } on Exception catch (e) {
      SnackBars.showErrorSnackBar("Error", e.toString());
    }
  }

  void deleteReward(Reward reward) {
    try {
      allRewardList.remove(reward);
      update(["allRewardList"]);
      LocalStorageService.saveAllRewardsToLocalStorage(allRewardList);
      SnackBars.showSuccessSnackBar("Success", "The Reward has been deleted");
    } on Exception catch (e) {
      SnackBars.showErrorSnackBar("Error", e.toString());
    }
  }

  void completeHabitAt(int todaysListIndex) {
    if (todaysHabitList.isNotEmpty) todaysHabitList.removeAt(todaysListIndex);

    LocalStorageService.saveAllHabitsToLocalStorage(allHabitList);
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
      name: "Eat some sweets",
      id: Uuid().v1(),
      description: "...",
    ),
    Reward(
      name: "Watch your favourite show",
      id: Uuid().v1(),
      description: "20 minute Adventure",
    ),
    Reward(
      name: "Sleep late",
      id: Uuid().v1(),
      description: "A very powerful nap",
    ),
    Reward(
      name: "Take a Day off",
      id: Uuid().v1(),
      description: "Be the lazy Bird",
    ),
  ];

  void addReward(Reward reward) {
    allRewardList.add(reward);
    LocalStorageService.saveAllRewardsToLocalStorage(allRewardList);
  }
}
