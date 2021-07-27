import 'package:Marbit/services/local_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:Marbit/models/models.dart';
import 'package:Marbit/util/constants.dart';
import 'package:flutter/material.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotifyController extends GetxController {
  @override
  Future<void> onInit() async {
    await _configureLocalTimeZone();
    super.onInit();
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<bool> initializeNotificationPlugin() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/launcher_icon");
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    return flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future<void> scheduleWeeklyHabitNotifications(
      List<NotificationObject> notificationObjects) async {
    for (NotificationObject _object in notificationObjects) {
      await _createNotificationFromObject(_object);
    }
  }

  Future<void> checkAndHandleNotificationRescheduling(
      NotificationObject object) async {
    final tz.TZDateTime _now = tz.TZDateTime.now(tz.local);

    final tz.TZDateTime _scheduledTime = tz.TZDateTime(
        tz.local, _now.year, _now.month, _now.day, object.hour, object.minutes);

    final bool _wasCompletedBeforeScheduledTime = _now.isBefore(_scheduledTime);

    if (!_wasCompletedBeforeScheduledTime) return;

    await flutterLocalNotificationsPlugin.cancel(object.notificationId);

    await LocalStorageService.saveObjectForRescheduling(object);
  }

  Future<void> updateAllHabitNotifications(
      {List<NotificationObject> oldObjects,
      List<NotificationObject> newObjects}) async {
    for (var i = 0; i < oldObjects.length; i++) {
      await flutterLocalNotificationsPlugin
          .cancel(oldObjects[i].notificationId);
    }
    for (var i = 0; i < newObjects.length; i++) {
      final NotificationObject _object = newObjects[i];
      await _createNotificationFromObject(_object);
    }
  }

  Future<void> updateHabitNotificationsPartially(
      {List<NotificationObject> oldObjects,
      List<NotificationObject> newObjects}) async {
    final List<NotificationObject> _objectsToDelete =
        _getListDifferences(oldObjects, newObjects);

    final List<NotificationObject> _objectsToCreate =
        _getListDifferences(newObjects, oldObjects);

    for (final notificationObject in _objectsToDelete) {
      await flutterLocalNotificationsPlugin
          .cancel(notificationObject.notificationId);
    }

    for (final notificationObject in _objectsToCreate) {
      await _createNotificationFromObject(notificationObject);
    }
  }

  List<NotificationObject> _getListDifferences(
      List<NotificationObject> listA, List<NotificationObject> listB) {
    final List<NotificationObject> _differences = [];
    for (final NotificationObject objA in listA) {
      bool found = false;
      for (final NotificationObject objB in listB) {
        if (objA.notificationId == objB.notificationId) {
          found = true;
          break;
        }
      }
      if (!found) {
        _differences.add(objA);
      }
    }
    return _differences;
  }

  Future<void> _createNotificationFromObject(NotificationObject object) async {
    final tz.TZDateTime _schedule = _nextInstanceOfDayAndTime(
        weekday: object.weekDay, hour: object.hour, minutes: object.minutes);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        object.notificationId,
        object.title,
        object.body,
        _schedule,
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

  tz.TZDateTime _nextInstanceOfDayAndTime(
      {int weekday, int hour, int minutes}) {
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

  Future<void> utilCancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> cancelAllHabitNotifications(Habit habit) async {
    for (var i = 0; i < habit.notificationObjects.length; i++) {
      final int _cancellationID = habit.notificationObjects[i].notificationId;
      await flutterLocalNotificationsPlugin.cancel(_cancellationID);
    }
  }

  Future<void> listScheduledNotifications(BuildContext context) async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: pendingNotificationRequests.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Text(
                    pendingNotificationRequests[index].id.toString(),
                    style: const TextStyle(color: kDeepOrange),
                  ),
                  title: Text(
                    pendingNotificationRequests[index].title,
                    style: const TextStyle(color: kDeepOrange),
                  ),
                  trailing: Text(pendingNotificationRequests[index].payload),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: Text(title),
    //     content: Text(body),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: Text('Ok'),
    //         onPressed: () async {
    //           Navigator.of(context, rootNavigator: true).pop();
    //           await Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => SecondScreen(payload),
    //             ),
    //           );
    //         },
    //       )
    //     ],
    //   ),
    // );
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }

    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }
}
