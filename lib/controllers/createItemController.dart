import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/services/localStorage.dart';
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

  RxList<String> selectedRewardReferences = List<String>.empty().obs;
  RxList<int> scheduledDays = List<int>.empty().obs;
  Rx<int> completionGoalCount = 1.obs;
  Rx<bool> isSelfRemovingReward = false.obs;
  Rx<bool> createHabit = false.obs;

  final NotificationTimesController _notificationTimesController =
      Get.find<NotificationTimesController>();

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

  Future<void> createAndSaveHabit() async {
    scheduledDays.sort();
    int nextScheduledWeekday = scheduledDays.firstWhere(
        (element) => element >= DateUtilities.today.weekday,
        orElse: () => scheduledDays.first);
    int prefix = await _getNotificationIDprefix();
    Habit newHabit = Habit(
      title: createTitleTextController.text,
      id: Uuid().v4(),
      completionGoal: completionGoalCount.value,
      description: createDescriptionController.text,
      scheduledWeekDays: scheduledDays,
      rewardIDReferences: selectedRewardReferences,
      trackedCompletions: _createInitialTrackedCompletions(),
      streak: 0,
      nextCompletionDate: DateUtilities.getDateTimeOfNextWeekDayOccurrence(
          nextScheduledWeekday),
      notificationIDprefix: prefix,
      notificationObjects: NotificationObject.createNotificationObjects(
          prefix: prefix,
          scheduledDays: scheduledDays,
          completionGoal: completionGoalCount.value,
          hours: _notificationTimesController.selectedHours,
          minutes: _notificationTimesController.selectedMinutes,
          title: createTitleTextController.text,
          body: ""),
    );
    await Get.find<NotifyController>()
        .scheduleWeeklyHabitNotifications(newHabit.notificationObjects);
    Get.find<ContentController>().saveNewHabit(newHabit);
  }

  Future<int> _getNotificationIDprefix() async {
    int _prefix = await LocalStorageService.loadLatestNotificationIDprefix();
    await LocalStorageService.saveLatestNotificationIDprefix(_prefix + 1);
    return _prefix;
  }

  TrackedCompletions _createInitialTrackedCompletions() {
    List<int> thisWeeksDates = DateUtilities.getCurrentWeeksDateList();
    DateTime _today = DateUtilities.today;

    return TrackedCompletions(
      trackedYears: [
        Year(
          yearCount: _today.year,
          calendarWeeks: [
            CalendarWeek(
              weekNumber: DateUtilities.currentCalendarWeek,
              trackedDays: List.generate(
                7,
                (index) {
                  return TrackedDay(
                      dayCount: thisWeeksDates[index],
                      doneAmount: 0,
                      goalAmount: completionGoalCount.value);
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
        isSelfRemoving: isSelfRemovingReward.value,
        description: createDescriptionController.text);
    Get.find<ContentController>().saveNewReward(newReward);
  }
}
