import 'package:Marbit/models/models.dart';
import 'package:Marbit/util/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:uuid/uuid.dart';
import 'contentController.dart';

class CreateItemController extends GetxController {
  RichTextController createTitleTextController;
  TextEditingController createDescriptionController;
  //TODO remove these controllers
  TextEditingController minTextController = TextEditingController();
  TextEditingController maxTextController = TextEditingController();

  List<String> selectedRewardReferences = [];
  List<int> scheduledDays = [];
  int completionGoalCount = 1;
  bool isSelfRemovingReward = false;

  @override
  void onInit() {
    createTitleTextController = RichTextController(
      patternMap: {
        RegExp(r"\s\b[0-9 0-9]+[-]+[0-9 0-9]\b"): TextStyle(
            backgroundColor: kLightOrange.withOpacity(0.5),
            fontWeight: FontWeight.bold)
      },
    );
    createDescriptionController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    createTitleTextController.dispose();
    createDescriptionController.dispose();
    super.onClose();
  }

  void createAndSaveHabit() {
    scheduledDays.sort();
    DateTime _today = DateUtilits.today;
    int nextScheduledWeekday = scheduledDays.firstWhere(
        (element) => element >= DateUtilits.today.weekday,
        orElse: () => scheduledDays.first);
    Habit newHabit = Habit(
      creationDate: _today,
      title: createTitleTextController.text,
      id: Uuid().v4(),
      completionGoal: completionGoalCount,
      description: createDescriptionController.text,
      scheduledWeekDays: scheduledDays,
      rewardIDReferences: selectedRewardReferences,
      trackedCompletions: _createInitialTrackedCompletions(),
      streak: 0,
      nextCompletionDate:
          DateUtilits.getDateTimeOfNextWeekDayOccurrence(nextScheduledWeekday),
    );
    Get.find<ContentController>().saveNewHabit(newHabit);
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

  void createAndSaveReward() {
    Reward newReward = Reward(
        name: createTitleTextController.text,
        id: Uuid().v4(),
        isSelfRemoving: isSelfRemovingReward,
        description: createDescriptionController.text);
    Get.find<ContentController>().saveNewReward(newReward);
  }
}
