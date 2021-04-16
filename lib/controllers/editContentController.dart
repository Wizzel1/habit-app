import 'package:Marbit/models/models.dart';
import 'package:Marbit/services/services.dart';
import 'package:Marbit/util/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers.dart';

class EditContentController extends GetxController {
  final ContentController _contentController = Get.find<ContentController>();

  TextEditingController titleController;
  TextEditingController descriptionController;
  bool isSelfRemoving;
  int newCompletionGoal;
  List<int> newSchedule = [];
  List<String> newRewardReferences = [];

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

  void loadHabitIntoEditContentController(Habit habit) {
    titleController.text = habit.title;
    descriptionController.text = habit.description;
    newCompletionGoal = habit.completionGoal;

    for (var i = 0; i < habit.scheduledWeekDays.length; i++) {
      newSchedule.add(habit.scheduledWeekDays[i]);
    }
    for (var i = 0; i < habit.rewardIDReferences.length; i++) {
      newRewardReferences.add(habit.rewardIDReferences[i]);
    }
  }

  void loadRewardIntoEditContentController(Reward reward) {
    titleController.text = reward.name;
    descriptionController.text = reward.description;
    isSelfRemoving = reward.isSelfRemoving;
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
          isSelfRemoving;
    LocalStorageService.saveAllRewardsToLocalStorage(
        _contentController.allRewardList);

    _contentController.updateRewardList();
  }

  void updateHabit(String habitID) {
    assert(habitID != null, "update habit was called on a null ID");

    if (habitID == null) return;
    int _updateIndex;
    _updateIndex = _contentController.allHabitList
        .indexWhere((element) => element.id == habitID);

    assert(_updateIndex != null);
    assert(_updateIndex >= 0, "updateindex must not be negative");

    newSchedule?.sort();

    Habit _habitToUpdate = _contentController.allHabitList[_updateIndex];

    if (titleController.text != null && titleController.text.isNotEmpty)
      _habitToUpdate.title = titleController.text;
    if (descriptionController.text != null &&
        descriptionController.text.isNotEmpty)
      _habitToUpdate.description = descriptionController.text;
    if (newSchedule != null && newSchedule.isNotEmpty)
      _habitToUpdate.scheduledWeekDays = newSchedule;
    if (newRewardReferences != null && newRewardReferences.isNotEmpty)
      _habitToUpdate.rewardIDReferences = newRewardReferences;
    if (newCompletionGoal != null)
      _habitToUpdate.completionGoal = newCompletionGoal;

    // _habitToUpdate.updateToNextCompletionDate();

    LocalStorageService.saveAllHabitsToLocalStorage(
        _contentController.allHabitList);

    _contentController.updateHabitList();
    _contentController.reloadHabitList();
  }

  // //TODO improve this method
  // bool isValidOrShowSnackbar(dynamic dynamicData) {
  //   //TODO prevent data saving
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
