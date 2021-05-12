import 'dart:convert';
import 'package:Marbit/models/models.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == "rescheduleNotifications") {
      await _configureLocalTimeZone();
      print("configured timezones");

      List<NotificationObject> _skippedNotificationObjects =
          await _loadSharedSkippedNotifications();

      if (_skippedNotificationObjects == null) return Future.value(true);

      final tz.TZDateTime _now = tz.TZDateTime.now(tz.local);
      print("$_now");

      List<NotificationObject> _rescheduledObjects = [];

      for (NotificationObject object in _skippedNotificationObjects) {
        print("checking ${object.title}");

        if (!_isLaterThanObjectsSchedule(_now, object)) continue;

        await _createNotificationFromObject(object);
        print("created new notification");

        _rescheduledObjects.add(object);
      }
      for (NotificationObject object in _rescheduledObjects) {
        _skippedNotificationObjects.removeWhere(
            (element) => element.notificationId == object.notificationId);
        print("removed ${object.title} from skippedList");
      }
      await _saveSharedNewSkippedObjects(_skippedNotificationObjects);
      return Future.value(true);
    }
    return Future.value(true);
  });
}

bool _isLaterThanObjectsSchedule(tz.TZDateTime now, NotificationObject object) {
  bool _isLaterWeekday = now.weekday != object.weekDay;
  bool _isLaterHour = now.hour > object.hour;
  bool _isLaterMinutes = now.minute > object.minutes;
  if (_isLaterWeekday) return true;
  print("isLaterWeekday : $_isLaterWeekday");
  if (_isLaterHour) return true;
  print("isLaterHour : $_isLaterHour");
  if (_isLaterMinutes) return true;
  print("isLaterMinutes : $_isLaterMinutes");
  return false;
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

Future<List<NotificationObject>> _loadSharedSkippedNotifications() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> _encodedObjects =
      prefs.getStringList("reschedulingNotifications");

  if (_encodedObjects == null) {
    print("no encoded objects found");
    return null;
  }

  List<dynamic> _decodedObjects =
      _encodedObjects.map((e) => jsonDecode(e)).toList();

  if (_decodedObjects == null) {
    print("unable to decode objects");
    return null;
  }

  List<NotificationObject> _notificationObjects =
      _decodedObjects.map((e) => NotificationObject.fromJson(e)).toList();
  print("returning ${_notificationObjects.length} objects");

  return _notificationObjects;
}

Future<void> _saveSharedNewSkippedObjects(
    List<NotificationObject> newObjects) async {
  if (newObjects == null) return;
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> _encodedObjects = [];

  newObjects.forEach((element) {
    _encodedObjects.add(jsonEncode(element.toJson()));
    print("added ${element.title} to encoded objects");
  });

  await prefs.setStringList("reschedulingNotifications", _encodedObjects);
}

Future<void> _createNotificationFromObject(NotificationObject object) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final tz.TZDateTime _scheduledTime = _nextInstanceOfDayAndTime(
      weekday: object.weekDay, hour: object.hour, minutes: object.minutes);

  await flutterLocalNotificationsPlugin.zonedSchedule(
      object.notificationId,
      object.title,
      object.body,
      _scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'weekly notification channel id',
          'weekly notification channel name',
          'weekly notificationdescription',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
}

tz.TZDateTime _nextInstanceOfDayAndTime({int weekday, int hour, int minutes}) {
  tz.TZDateTime scheduledDate =
      _nextInstanceOfTime(hour: hour, minutes: minutes);
  while (scheduledDate.weekday != weekday) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

tz.TZDateTime _nextInstanceOfTime({int hour, int minutes}) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime _scheduledDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes, 0);
  if (_scheduledDate.isBefore(now)) {
    _scheduledDate = _scheduledDate.add(const Duration(days: 1));
  }
  return _scheduledDate;
}
