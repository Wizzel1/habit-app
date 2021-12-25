import 'package:Marbit/models/models.dart';
import 'package:Marbit/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'controllers.dart';

class NotificationTimesController extends GetxController {
  RxList<int>? selectedHours;
  RxList<int>? selectedMinutes;

  TextEditingController? hourController;
  TextEditingController? minuteController;

  @override
  void onInit() {
    hourController = TextEditingController();
    minuteController = TextEditingController();

    selectedHours = List<int>.generate(
            ContentController.maxDailyCompletions, (index) => 12 + index,
            growable: false)
        .obs;
    selectedMinutes = List<int>.generate(
            ContentController.maxDailyCompletions, (_) => 00,
            growable: false)
        .obs;
    super.onInit();
  }

  void setControllerValues(int index) {
    hourController!.text = selectedHours![index].toString();
    minuteController!.text = selectedMinutes![index].toString();
  }

  bool saveSelectedTimeTo(int index) {
    final int? _hour = int.tryParse(hourController!.text);
    final int? _minute = int.tryParse(minuteController!.text);

    if (_hour == null || _minute == null) {
      _showWarningSnackBar();
      return false;
    }

    final bool _invalidHour = _hour >= 24;
    final bool _invalidMinute = _minute >= 60;

    if (_invalidHour || _invalidMinute) {
      _showWarningSnackBar();
      return false;
    }

    selectedHours![index] = int.parse(hourController!.text);
    selectedMinutes![index] = int.parse(minuteController!.text);

    Get.find<EditContentController>().hasChangedNotificationInformation = true;
    return true;
  }

  void _showWarningSnackBar() {
    SnackBars.showWarningSnackBar(
        'invalid_time_title'.tr, 'invalid_time_message'.tr);
  }

  void _setMinMaxTimes(int changeIndex) {
    final int _changedHour = selectedHours![changeIndex];
    final int _changedMinute = selectedMinutes![changeIndex];

    for (var i = 0; i < selectedHours!.length; i++) {
      if (i == changeIndex) continue;
      if (i < changeIndex) {
        if (selectedHours![i] >= _changedHour) {
          if (_changedMinute == 30) {
            selectedMinutes![i] = 00;
            selectedHours![i] = _changedHour;
          } else {
            selectedMinutes![i] = 30;
            selectedHours![i] = (_changedHour - 1).clamp(0, 23);
          }
        }
      }
      if (i > changeIndex) {
        if (selectedHours![i] <= _changedHour) {
          if (_changedMinute == 30) {
            selectedMinutes![i] = 00;
            selectedHours![i] = (_changedHour + 1).clamp(0, 23);
          } else {
            selectedMinutes![i] = 30;
            selectedHours![i] = _changedHour;
          }
        }
      }
    }
  }

  void setNotificationTimes(List<NotificationObject> objectList) {
    final List<String> _times = [];
    for (var i = 0; i < objectList.length; i++) {
      final NotificationObject _object = objectList[i];
      final String stringTime = _object.hour.toString().padLeft(2, "0") +
          _object.minutes.toString().padRight(2, "0");

      if (_times.contains(stringTime)) continue;
      _times.add(stringTime);
    }

    _times.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    for (var i = 0; i < _times.length; i++) {
      selectedHours![i] = int.parse(_times[i].substring(0, 2));
      selectedMinutes![i] = int.parse(_times[i].substring(2, 4));
    }
  }
}
