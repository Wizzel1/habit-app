import 'dart:convert';

import 'package:Marbit/models/models.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

import '../models/models.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == "rescheduleNotifications") {
      await _configureLocalTimeZone();

      final List<NotificationObject> _skippedNotificationObjects =
          await _loadSharedSkippedNotifications();

      if (_skippedNotificationObjects == null) return Future.value(true);

      final tz.TZDateTime _now = tz.TZDateTime.now(tz.local);

      final List<NotificationObject> _rescheduledObjects = [];

      for (final NotificationObject object in _skippedNotificationObjects) {
        if (!_isLaterThanObjectsSchedule(_now, object)) continue;

        await _createNotificationFromObject(object);

        _rescheduledObjects.add(object);
      }
      for (final NotificationObject object in _rescheduledObjects) {
        _skippedNotificationObjects.removeWhere(
            (element) => element.notificationId == object.notificationId);
      }
      await _saveSharedNewSkippedObjects(_skippedNotificationObjects);
      return Future.value(true);
    }
    return Future.value(true);
  });
}

bool _isLaterThanObjectsSchedule(tz.TZDateTime now, NotificationObject object) {
  final bool _isLaterWeekday = now.weekday != object.weekDay;
  final bool _isLaterHour = now.hour > object.hour;
  final bool _isLaterMinutes = now.minute > object.minutes;
  if (_isLaterWeekday) return true;
  if (_isLaterHour) return true;
  if (_isLaterMinutes) return true;
  return false;
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

Future<List<NotificationObject>> _loadSharedSkippedNotifications() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final List<String> _encodedObjects =
      prefs.getStringList("reschedulingNotifications");

  if (_encodedObjects == null) {
    return null;
  }

  final List<dynamic> _decodedObjects =
      _encodedObjects.map((e) => jsonDecode(e)).toList();

  if (_decodedObjects == null) {
    return null;
  }

  final List<NotificationObject> _notificationObjects = _decodedObjects
      .map((e) => NotificationObject.fromJson(e as Map<String, dynamic>))
      .toList();

  return _notificationObjects;
}

Future<void> _saveSharedNewSkippedObjects(
    List<NotificationObject> newObjects) async {
  if (newObjects == null) return;
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final List<String> _encodedObjects = [];

  for (final NotificationObject object in newObjects) {
    _encodedObjects.add(jsonEncode(object.toJson()));
  }

  await prefs.setStringList("reschedulingNotifications", _encodedObjects);
}

Future<void> _createNotificationFromObject(NotificationObject object) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
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
          channelDescription: 'weekly notificationdescription',
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
      tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
  if (_scheduledDate.isBefore(now)) {
    _scheduledDate = _scheduledDate.add(const Duration(days: 1));
  }
  return _scheduledDate;
}
