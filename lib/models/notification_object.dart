// To parse this JSON data, do
//
//     final notificationObject = notificationObjectFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

NotificationObject notificationObjectFromJson(String str) =>
    NotificationObject.fromJson(json.decode(str) as Map<String, dynamic>);

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
  int? notificationId;

  /// The completion step that this Object was created for.
  /// It is used to reschedule Notifications for AheadOfScheduledTime-Completed completionSteps.
  ///
  /// So if the parent Habits completionGoal is 4, this number can be 1-4.
  int? relatedCompletionStep;

  /// The hour (0-23) to schedule.
  int? hour;

  /// The minute (0-59) to schedule.
  int? minutes;

  /// The weekDay (1-7) to schedule.
  int? weekDay;

  /// The title of the scheduled Notification.
  String? title;

  /// The body of the scheduled Notification.
  String? body;

  NotificationObject({
    required this.notificationId,
    required this.hour,
    required this.minutes,
    required this.weekDay,
    required this.title,
    required this.body,
    required this.relatedCompletionStep,
  });

  factory NotificationObject.fromJson(Map<String, dynamic> json) =>
      NotificationObject(
          notificationId: json["notificationID"] as int?,
          hour: json["hour"] as int?,
          minutes: json["minutes"] as int?,
          weekDay: json["weekDay"] as int?,
          title: json["title"] as String?,
          body: json["body"] as String?,
          relatedCompletionStep: json["relatedCompletionStep"] as int?);

  Map<String, dynamic> toJson() => {
        "notificationID": notificationId,
        "hour": hour,
        "minutes": minutes,
        "weekDay": weekDay,
        "title": title,
        "body": body,
        "relatedCompletionStep": relatedCompletionStep,
      };

  static List<NotificationObject> createNotificationObjects({
    List<int?>? activeNotifications,
    int? prefix,
    required List<int> scheduledDays,
    int? completionGoal,
    List<int>? hours,
    List<int>? minutes,
    String? title,
    String? body,
  }) {
    final List<NotificationObject> _objectList = [];

    for (var i = 0; i < scheduledDays.length; i++) {
      final int _currentWeekday = scheduledDays[i];
      for (var j = 0; j < completionGoal!; j++) {
        final int _completionStep = j + 1;
        if (!activeNotifications!.contains(_completionStep)) continue;
        final NotificationObject _newObject = NotificationObject(
            notificationId: int.parse(
                "$prefix$_currentWeekday$_completionStep${hours![j]}${minutes![j]}"),
            hour: hours[j],
            minutes: minutes[j],
            weekDay: _currentWeekday,
            title: title,
            body: body,
            relatedCompletionStep: _completionStep);

        _objectList.add(_newObject);
      }
    }
    _objectList.sort((a, b) => a.notificationId!.compareTo(b.notificationId!));
    return _objectList;
  }
}
