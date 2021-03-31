import 'package:Marbit/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/services/localStorage.dart';
import 'package:uuid/uuid.dart';

class ContentController extends GetxController {
  //TODO: Replace this rewards implementation by creating an initial binding

  static const int maxDailyCompletions = 7;

  static final Habit tutorialHabit = Habit(
      title: "Example",
      id: "testHabit",
      description: "This is an example Habit.",
      scheduledWeekDays: [1, 2, 3, 4, 5],
      rewardList: [],
      trackedCompletions: DateUtilits.get2021ExampleCompletions(),
      completionGoal: 5);

  List<Reward> allRewardList = [];
  List<Habit> allHabitList = [];
  final RxList todaysList = [].obs;

  void addHabit(Habit habit) {
    if (habit.isScheduledForToday()) {
      todaysList.add(habit);
    }
    allHabitList.add(habit);
    LocalStorageService.saveAllHabitsToLocalStorage(allHabitList);
  }

  void updateHabit(
      {String habitID,
      String newTitle,
      String newDescription,
      int newCompletionGoal,
      List<int> newSchedule,
      List<Reward> newRewardList}) {
    int _updateIndex =
        allHabitList.indexWhere((element) => element.id == habitID);

    newSchedule.sort();
    allHabitList[_updateIndex].title = newTitle;
    allHabitList[_updateIndex].description = newDescription;
    allHabitList[_updateIndex].scheduledWeekDays = newSchedule;
    allHabitList[_updateIndex].rewardList = newRewardList;
    allHabitList[_updateIndex].completionGoal = newCompletionGoal;
    update(["allList"]);

    LocalStorageService.saveAllHabitsToLocalStorage(allHabitList);
    reloadHabitList();
  }

  void deleteHabit(Habit habit) {
    //TODO: probably needs improvement
    allHabitList.remove(habit);
    update(["allList"]);
    LocalStorageService.saveAllHabitsToLocalStorage(allHabitList);
    reloadHabitList();
  }

  void completeHabitAt(int todaysListIndex) {
    Habit _completedHabit = todaysList.removeAt(todaysListIndex);
    // int _completedHabitIndex =
    //     allHabitList.indexWhere((element) => element.id == _completedHabit.id);
    //allHabitList[_completedHabitIndex].addCompletionForToday();

    LocalStorageService.saveAllHabitsToLocalStorage(allHabitList);
  }

  @override
  void onInit() {
    //LocalStorageService.storageBox.erase();
    super.onInit();
  }

  void reloadHabitList() {
    if (allHabitList.isEmpty) return;
    todaysList.clear();
    for (var i = 0; i < allHabitList.length; i++) {
      if (allHabitList[i].isScheduledForToday() &&
          !allHabitList[i].wasFinishedToday()) {
        todaysList.add(allHabitList[i]);
      }
    }
  }

  Future<void> initializeContent() async {
    allHabitList = await LocalStorageService.loadHabitsFromLocalStorage();
    allRewardList = await LocalStorageService.loadRewardsFromLocalStorage();

    if (allHabitList.isEmpty) return;

    for (var i = 0; i < allHabitList.length; i++) {
      if (allHabitList[i].isScheduledForToday() &&
          !allHabitList[i].wasFinishedToday()) {
        todaysList.add(allHabitList[i]);
      }
    }
    catchUpInactiveDays();
    LocalStorageService.saveLatestActiveDay();
    LocalStorageService.saveAllHabitsToLocalStorage(allHabitList);
  }

  void catchUpInactiveDays() {
    DateTime _latestDateActive = LocalStorageService.getLatestActiveDay();
    //TODO: Instead of returning, this should fill the difference between creationdate and today for each habit
    if (_latestDateActive == null) return;

    DateTime _today =
        DateTime.parse(DateUtilits.formatter.format(DateTime.now()));
    if (_latestDateActive == DateTime.now()) return;

    Duration _inactiveDuration = _today.difference(_latestDateActive);
    int _inactiveDaysCount = _inactiveDuration.inDays;

    // for (var i = 0; i < _inactiveDaysCount; i++) {
    //   String _day =
    //       DateUtilits.formatter.format(_today.subtract(Duration(days: i)));
    //   for (var i = 0; i < allHabitList.length; i++) {
    //     if (allHabitList[i].trackedCompletions[_day] == null)
    //       allHabitList[i].trackedCompletions[_day] = false;
    //   }
    // }
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
