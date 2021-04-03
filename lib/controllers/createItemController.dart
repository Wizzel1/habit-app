import 'package:Marbit/models/models.dart';
import 'package:Marbit/util/dateUtilitis.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:Marbit/models/habitModel.dart';
import 'package:Marbit/models/rewardModel.dart';
import 'package:uuid/uuid.dart';
import 'contentController.dart';

class CreateItemController extends GetxController {
  final TextEditingController createTitleTextController =
      TextEditingController();
  final TextEditingController createDescriptionController =
      TextEditingController();
  List<Reward> selectedRewards = [];
  List<int> scheduledDays = [];
  int completionGoalCount = 1;
  bool isSelfRemovingReward = false;

  void resetCreationControllers() {
    createTitleTextController.text != null
        ? createTitleTextController.clear()
        : null;
    createDescriptionController.text != null
        ? createDescriptionController.clear()
        : null;
    scheduledDays = [];
    selectedRewards = [];
    isSelfRemovingReward = false;
    completionGoalCount = 1;
  }

  void createHabit() {
    scheduledDays.sort();
    DateTime _today = DateUtilits.today;
    Habit newHabit = Habit(
      creationDate: _today,
      title: createTitleTextController.text,
      id: Uuid().v1(),
      completionGoal: completionGoalCount,
      description: createDescriptionController.text,
      scheduledWeekDays: scheduledDays,
      rewardList: selectedRewards,
      trackedCompletions: _createInitialTrackedCompletions(),
    );
    Get.find<ContentController>().addHabit(newHabit);
    resetCreationControllers();
  }

  TrackedCompletions _createInitialTrackedCompletions() {
    List<int> thisWeeksDates = DateUtilits.getCurrentWeeksDateList();
    DateTime _today = DateUtilits.today;

    return TrackedCompletions(
      trackedYears: [
        Year(
          yearCount: _today.year,
          calendarWeeks: [
            CalendarWeek(
              weekNumber: DateUtilits.currentCalendarWeek,
              trackedDays: List.generate(
                7,
                (index) {
                  return TrackedDay(
                      dayCount: thisWeeksDates[index],
                      doneAmount: 0,
                      goalAmount: completionGoalCount);
                },
              ),
            )
          ],
        )
      ],
    );
  }

  void createReward() {
    Reward newReward = Reward(
        name: createTitleTextController.text,
        id: Uuid().v1(),
        isSelfRemoving: isSelfRemovingReward,
        description: createDescriptionController.text);
    Get.find<ContentController>().addReward(newReward);
    resetCreationControllers();
  }
}
