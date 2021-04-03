import 'package:Marbit/util/util.dart';
import 'package:get/get.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/services/localStorage.dart';
import 'package:uuid/uuid.dart';

class ContentController extends GetxController {
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
  final RxList todaysHabitList = [].obs;

  void addHabit(Habit habit) {
    if (habit.isScheduledForToday()) {
      todaysHabitList.add(habit);
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
    int _updateIndex;

    if (habitID != null) {
      _updateIndex =
          allHabitList.indexWhere((element) => element.id == habitID);
    }

    newSchedule?.sort();
    if (newTitle != null) allHabitList[_updateIndex].title = newTitle;
    if (newDescription != null)
      allHabitList[_updateIndex].description = newDescription;
    if (newSchedule != null)
      allHabitList[_updateIndex].scheduledWeekDays = newSchedule;
    if (newRewardList != null)
      allHabitList[_updateIndex].rewardList = newRewardList;
    if (newCompletionGoal != null)
      allHabitList[_updateIndex].completionGoal = newCompletionGoal;

    LocalStorageService.saveAllHabitsToLocalStorage(allHabitList);
    update(["allList"]);
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

  void reloadHabitList() {
    if (allHabitList.isEmpty) return;
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
