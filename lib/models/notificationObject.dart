// To parse this JSON data, do
//
//     final notificationObject = notificationObjectFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

NotificationObject notificationObjectFromJson(String str) =>
    NotificationObject.fromJson(json.decode(str));

String notificationObjectToJson(NotificationObject data) =>
    json.encode(data.toJson());

/// A [NotificationObject] holds Information about a single scheduled Notification from a Habit.
class NotificationObject {
  /// The [notificationId] is prefixed by the Habit's [notificationIDprefix].
  ///
  /// Followed by the scheduled [weekDay] (1-7).
  ///
  /// Followed by the index of the completionGoal (1-7) to create a unique reference.
  ///
  /// Followed by the hours and the minutes.
  ///
  /// Example:
  ///
  /// Habits prefix = 23
  ///
  /// Weekday = 7 (Sunday)
  ///
  /// CompletionGoal is 4 and this Object represents the notification for the last daily completion = 4
  ///
  /// Hours = 23, Minutes = 30
  ///
  /// notificationId = 23742330
  int notificationId;

  /// The hour (0-23) to schedule.
  int hour;

  /// The minute (0-59) to schedule.
  int minutes;

  /// The weekDay (1-7) to schedule.
  int weekDay;

  /// Wether or not the Notification should be shown.
  bool shouldShow;

  /// The title of the scheduled Notification.
  String title;

  /// The body of the scheduled Notification.
  String body;

  NotificationObject({
    @required this.notificationId,
    @required this.hour,
    @required this.minutes,
    @required this.weekDay,
    @required this.shouldShow,
    @required this.title,
    @required this.body,
  });

  factory NotificationObject.fromJson(Map<String, dynamic> json) =>
      NotificationObject(
        notificationId: json["notificationID"],
        hour: json["hour"],
        minutes: json["minutes"],
        weekDay: json["weekDay"],
        shouldShow: json["shouldShow"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "notificationID": notificationId,
        "hour": hour,
        "minutes": minutes,
        "weekDay": weekDay,
        "shouldShow": shouldShow,
        "title": title,
        "body": body,
      };

  static List<NotificationObject> createNotificationObjects({
    int prefix,
    List<int> scheduledDays,
    int completionGoal,
    List<int> hours,
    List<int> minutes,
    String title,
    String body,
  }) {
    List<NotificationObject> _objectList = [];

    for (var i = 0; i < scheduledDays.length; i++) {
      for (var j = 0; j < completionGoal; j++) {
        int _currentWeekday = scheduledDays[i];
        NotificationObject _newObject = NotificationObject(
            notificationId:
                int.parse("$prefix$_currentWeekday$j${hours[j]}${minutes[j]}"),
            hour: hours[j],
            minutes: minutes[j],
            weekDay: _currentWeekday,
            shouldShow: true,
            title: title,
            body: body);

        _objectList.add(_newObject);
      }
    }
    _objectList.sort((a, b) => a.notificationId.compareTo(b.notificationId));
    return _objectList;
  }
}
