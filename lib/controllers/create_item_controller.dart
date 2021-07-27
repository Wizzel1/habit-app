import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/services/local_storage.dart';
import 'package:Marbit/util/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:uuid/uuid.dart';

class CreateItemController extends GetxController {
  RichTextController createTitleTextController;

  RxList<String> selectedRewardReferences = List<String>.empty().obs;
  RxList<int> scheduledDays = List<int>.empty().obs;
  Rx<int> completionGoalCount = 1.obs;
  Rx<bool> isSelfRemovingReward = false.obs;
  Rx<bool> createHabit = false.obs;
  RxList<int> activeNotifications = List<int>.empty().obs;

  final NotificationTimesController _notificationTimesController =
      Get.find<NotificationTimesController>();

  @override
  void onInit() {
    createTitleTextController = RichTextController(
      patternMap: {
        RegExp(regexPattern): TextStyle(
            backgroundColor: kLightOrange.withOpacity(0.5),
            fontWeight: FontWeight.bold)
      },
    );
    super.onInit();
  }

  @override
  void onClose() {
    createTitleTextController.dispose();
    super.onClose();
  }

  void fillSchedule() {
    scheduledDays.value = [1, 2, 3, 4, 5, 6, 7];
  }

  void clearSchedule() {
    scheduledDays.value = [];
  }

  void toggleWeekDay(int index) {
    scheduledDays.contains(index + 1)
        ? scheduledDays.remove(index + 1)
        : scheduledDays.add(index + 1);
    scheduledDays.sort();
  }

  void toggleActiveNotification(int index) {
    activeNotifications.contains(index + 1)
        ? activeNotifications.remove(index + 1)
        : activeNotifications.add(index + 1);
  }

  void toggleReward(Reward reward) {
    selectedRewardReferences.contains(reward.id)
        ? selectedRewardReferences.remove(reward.id)
        : selectedRewardReferences.add(reward.id);
  }

  Future<void> createAndSaveHabit() async {
    scheduledDays.sort();
    final int nextScheduledWeekday = scheduledDays.firstWhere(
        (element) => element >= DateUtilities.today.weekday,
        orElse: () => scheduledDays.first);
    final int prefix = await _getNotificationIDprefix();
    final Habit newHabit = Habit(
      title: createTitleTextController.text,
      id: const Uuid().v4(),
      completionGoal: completionGoalCount.value,
      scheduledWeekDays: scheduledDays,
      rewardIDReferences: selectedRewardReferences,
      trackedCompletions: _createInitialTrackedCompletions(),
      streak: 0,
      nextCompletionDate: DateUtilities.getDateTimeOfNextWeekDayOccurrence(
          nextScheduledWeekday),
      notificationIDprefix: prefix,
      notificationObjects: NotificationObject.createNotificationObjects(
          activeNotifications: activeNotifications,
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
    final int _prefix =
        await LocalStorageService.loadLatestNotificationIDprefix();
    await LocalStorageService.saveLatestNotificationIDprefix(_prefix + 1);
    return _prefix;
  }

  bool performInputCheck({bool isHabit}) {
    if (isHabit) return _performTitleCheck() && _performScheduleCheck();
    if (!isHabit) return _performTitleCheck();
  }

  bool _performTitleCheck() {
    if (createTitleTextController.text == null) return false;
    if (!createTitleTextController.text.isBlank) return true;
    SnackBars.showWarningSnackBar('warning'.tr, 'title_missing_warning'.tr);
    return false;
  }

  bool _performScheduleCheck() {
    if (scheduledDays.isNotEmpty) return true;
    SnackBars.showWarningSnackBar('warning'.tr, 'missing_schedule_warning'.tr);
    return false;
  }

  TrackedCompletions _createInitialTrackedCompletions() {
    final List<int> thisWeeksDates = DateUtilities.getCurrentWeeksDateList();
    final DateTime _today = DateUtilities.today;

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
    final Reward newReward = Reward(
        name: createTitleTextController.text,
        id: const Uuid().v4(),
        isSelfRemoving: isSelfRemovingReward.value);
    Get.find<ContentController>().saveNewReward(newReward);
  }
}
