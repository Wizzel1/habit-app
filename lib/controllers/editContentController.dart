import 'package:Marbit/models/models.dart';
import 'package:Marbit/services/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers.dart';

class EditContentController extends GetxController {
  final ContentController _contentController = Get.find<ContentController>();
  final NotificationTimesController _notificationTimesController =
      Get.find<NotificationTimesController>();
  TextEditingController titleController;
  TextEditingController descriptionController;
  bool hasChangedNotificationTimes = false;
  Rx<bool> isSelfRemoving = false.obs;
  Rx<int> cachedCompletionGoal = 0.obs;
  RxList<int> cachedSchedule = List<int>.empty().obs;
  RxList<String> cachedRewardReferences = List<String>.empty().obs;
  Rx<DateTime> cachedCompletionDate = DateTime.now().obs;
  RxList<NotificationObject> cachedNotificationObjects =
      List<NotificationObject>.empty().obs;
  RxList<int> activeNotifications = List<int>.empty().obs;

  @override
  void onInit() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void loadHabitValues(Habit habit) {
    titleController.text = habit.title;
    descriptionController.text = habit.description;
    cachedCompletionGoal.value = habit.completionGoal;

    for (var i = 0; i < habit.scheduledWeekDays.length; i++) {
      cachedSchedule.add(habit.scheduledWeekDays[i]);
    }

    for (var i = 0; i < habit.rewardIDReferences.length; i++) {
      cachedRewardReferences.add(habit.rewardIDReferences[i]);
    }

    for (var i = 0; i < habit.notificationObjects.length; i++) {
      cachedNotificationObjects.add(habit.notificationObjects[i]);
    }

    for (var i = 0; i < habit.notificationObjects.length; i++) {
      final NotificationObject _object = habit.notificationObjects[i];
      if (activeNotifications.contains(_object.relatedCompletionStep)) continue;
      activeNotifications.add(_object.relatedCompletionStep);
    }

    _notificationTimesController
        .setNotificationTimes(cachedNotificationObjects);
  }

  void loadRewardValues(Reward reward) {
    titleController.text = reward.name;
    descriptionController.text = reward.description;
    isSelfRemoving.value = reward.isSelfRemoving;
  }

  void updateReward(String rewardID) {
    assert(rewardID != null, "update reward was called on a null ID");

    if (rewardID == null) return;
    int _updateIndex;
    _updateIndex = _contentController.allRewardList
        .indexWhere((element) => element.id == rewardID);

    assert(_updateIndex != null);
    assert(_updateIndex >= 0, "updateindex must not be negative");

    if (titleController.text != null)
      _contentController.allRewardList[_updateIndex].name =
          titleController.text;
    if (descriptionController.text != null)
      _contentController.allRewardList[_updateIndex].description =
          descriptionController.text;
    if (isSelfRemoving != null)
      _contentController.allRewardList[_updateIndex].isSelfRemoving =
          isSelfRemoving.value;

    LocalStorageService.saveAllRewards(_contentController.allRewardList);

    _contentController.updateRewardList();
  }

  void updateHabit(String habitID) async {
    assert(habitID != null, "update habit was called on a null ID");

    if (habitID == "tutorialHabit" || habitID == null) return;

    int _updateIndex;
    _updateIndex = _contentController.allHabitList
        .indexWhere((element) => element.id == habitID);

    assert(_updateIndex != null);
    assert(_updateIndex >= 0, "updateindex must not be negative");

    cachedSchedule?.sort();

    Habit _habitToUpdate = _contentController.allHabitList[_updateIndex];

    await _updateNotifications(_habitToUpdate);

    if (titleController.text != null && titleController.text.isNotEmpty)
      _habitToUpdate.title = titleController.text;
    if (descriptionController.text != null &&
        descriptionController.text.isNotEmpty)
      _habitToUpdate.description = descriptionController.text;
    if (cachedSchedule != null && cachedSchedule.isNotEmpty)
      _habitToUpdate.scheduledWeekDays = cachedSchedule;
    if (cachedRewardReferences != null && cachedRewardReferences.isNotEmpty)
      _habitToUpdate.rewardIDReferences = cachedRewardReferences;
    if (cachedCompletionGoal != null && cachedCompletionGoal.value != 0)
      _habitToUpdate.completionGoal = cachedCompletionGoal.value;

    _habitToUpdate.updateToNextCompletionDate();
    if (cachedCompletionDate != null)
      _habitToUpdate.nextCompletionDate = cachedCompletionDate.value;

    LocalStorageService.saveAllHabits(_contentController.allHabitList);

    _contentController.updateHabitList();
    _contentController.reloadHabitList();
  }

  Future<void> _updateNotifications(Habit habitToUpdate) async {
    if (titleController == null) return;
    if (titleController.text == null) return;
    if (cachedSchedule.isEmpty) return;
    if (cachedCompletionGoal.value == 0) return;

    final bool _hasChangedTitle = habitToUpdate.title != titleController.text;
    final bool _hasChangedSchedule =
        !listEquals(habitToUpdate.scheduledWeekDays, cachedSchedule);
    final bool _hasChangedCompletionGoal =
        habitToUpdate.completionGoal != cachedCompletionGoal.value;

    final bool _needsPartialNotificationUpdate = (_hasChangedCompletionGoal ||
        _hasChangedSchedule ||
        hasChangedNotificationTimes);
    final bool _needsCompleteNotificationUpdate = _hasChangedTitle;

    if (!_needsCompleteNotificationUpdate && !_needsPartialNotificationUpdate)
      return;

    final List<NotificationObject> _newObjects =
        NotificationObject.createNotificationObjects(
            prefix: habitToUpdate.notificationIDprefix,
            scheduledDays: cachedSchedule,
            completionGoal: cachedCompletionGoal.value,
            hours: _notificationTimesController.selectedHours,
            minutes: _notificationTimesController.selectedMinutes,
            title: titleController.text,
            body: "");

    if (_needsCompleteNotificationUpdate) {
      await Get.find<NotifyController>().updateAllHabitNotifications(
          oldObjects: habitToUpdate.notificationObjects,
          newObjects: _newObjects);
      return;
    }

    if (!_needsCompleteNotificationUpdate && _needsPartialNotificationUpdate) {
      await Get.find<NotifyController>().updateHabitNotificationsPartially(
          oldObjects: habitToUpdate.notificationObjects,
          newObjects: _newObjects);

      habitToUpdate.notificationObjects = _newObjects;
      return;
    }
  }

  // //TODO improve this method
  // bool isValidOrShowSnackbar(dynamic dynamicData) {
  //   if (dynamicData == null) return false;

  //   if (dynamicData is String) {
  //     dynamicData = dynamicData as String;
  //     if (dynamicData.isEmpty)
  //       SnackBars.showWarningSnackBar(
  //           'empty_field_warning_title'.tr, 'empty_field_warning_message'.tr);
  //     return false;
  //   }

  //   if (dynamicData is List<int>) {
  //     dynamicData = dynamicData as List<int>;
  //     if (dynamicData.isEmpty) {
  //       SnackBars.showWarningSnackBar('empty_schedule_warning_title'.tr,
  //           'empty_schedule_warning_message'.tr);
  //       return false;
  //     }
  //   }

  //   if (dynamicData is List<Reward>) {
  //     dynamicData = dynamicData as List<Reward>;
  //     if (dynamicData.isEmpty) {
  //       SnackBars.showWarningSnackBar(
  //           'no_rewards_warning_title'.tr, 'no_rewards_warning_message'.tr);
  //       return false;
  //     }
  //   }

  //   return true;
  // }
}
