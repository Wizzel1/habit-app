import 'package:Marbit/models/models.dart';
import 'package:get/get.dart';

import 'controllers.dart';

class NotificationTimesController extends GetxController {
  RxList<int> selectedHours;
  RxList<int> selectedMinutes;

  @override
  void onInit() {
    // TODO: implement onInit
    selectedHours = List<int>.generate(
            ContentController.maxDailyCompletions, (_) => 12,
            growable: false)
        .obs;
    selectedMinutes = List<int>.generate(
            ContentController.maxDailyCompletions, (_) => 00,
            growable: false)
        .obs;
    super.onInit();
  }

  void add30MinutesToIndex(int index) {
    if (selectedHours[index] == 23 && selectedMinutes[index] == 30) return;
    if (selectedMinutes[index] == 30) {
      selectedMinutes[index] = 00;
      selectedHours[index] = (selectedHours[index] + 1).clamp(0, 23);
    } else {
      selectedMinutes[index] = 30;
    }
    _setMinMaxTimes(index);
    Get.find<EditContentController>().hasChangedNotificationTimes = true;
  }

  void subtract30MinutesFromIndex(int index) {
    if (selectedHours[index] == 0 && selectedMinutes[index] == 00) return;
    if (selectedMinutes[index] == 00) {
      selectedMinutes[index] = 30;
      selectedHours[index] = (selectedHours[index] - 1).clamp(0, 23);
    } else {
      selectedMinutes[index] = 00;
    }
    _setMinMaxTimes(index);
    Get.find<EditContentController>().hasChangedNotificationTimes = true;
  }

  void _setMinMaxTimes(int changeIndex) {
    int _changedHour = selectedHours[changeIndex];
    int _changedMinute = selectedMinutes[changeIndex];

    for (var i = 0; i < selectedHours.length; i++) {
      if (i == changeIndex) continue;
      if (i < changeIndex) {
        if (selectedHours[i] >= _changedHour) {
          if (_changedMinute == 30) {
            selectedMinutes[i] = 00;
            selectedHours[i] = _changedHour;
          } else {
            selectedMinutes[i] = 30;
            selectedHours[i] = (_changedHour - 1).clamp(0, 23);
          }
        }
      }
      if (i > changeIndex) {
        if (selectedHours[i] <= _changedHour) {
          if (_changedMinute == 30) {
            selectedMinutes[i] = 00;
            selectedHours[i] = (_changedHour + 1).clamp(0, 23);
          } else {
            selectedMinutes[i] = 30;
            selectedHours[i] = _changedHour;
          }
        }
      }
    }
  }

  void setNotificationTimes(List<NotificationObject> objectList) {
    List<String> _times = [];
    for (var i = 0; i < objectList.length; i++) {
      NotificationObject _object = objectList[i];
      String stringTime = _object.hour.toString().padLeft(2, "0") +
          _object.minutes.toString().padRight(2, "0");

      if (_times.contains(stringTime)) continue;
      _times.add(stringTime);
    }

    _times.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    for (var i = 0; i < _times.length; i++) {
      selectedHours[i] = int.parse(_times[i].substring(0, 2));
      selectedMinutes[i] = int.parse(_times[i].substring(2, 4));
    }
  }
}
