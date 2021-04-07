import 'dart:convert';

import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/controllers/dateController.dart';
import 'package:Marbit/models/trackedCompletionsModel.dart';
import 'package:Marbit/util/constants.dart';
import 'package:Marbit/util/dateUtilitis.dart';
import 'package:Marbit/models/rewardModel.dart';
import 'package:Marbit/widgets/habitCompletionChart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Habit {
  String title;
  String id;
  DateTime creationDate;
  String description;
  List<int> scheduledWeekDays;
  List<String> rewardIDReferences;
  TrackedCompletions trackedCompletions;
  int completionGoal;

  //TODO: implement color serialization
  Map<String, int> habitColors = {
    "light": kLightOrange.value,
    "deep": kDeepOrange.value
  };

  Habit({
    @required this.title,
    @required this.description,
    @required this.id,
    @required this.creationDate,
    @required this.scheduledWeekDays,
    @required this.rewardIDReferences,
    @required this.trackedCompletions,
    @required this.completionGoal,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "id": id,
        "completionGoal": completionGoal,
        "creationDate":
            "${creationDate.year.toString().padLeft(4, '0')}-${creationDate.month.toString().padLeft(2, '0')}-${creationDate.day.toString().padLeft(2, '0')}",
        "scheduledWeekDays":
            List<dynamic>.from(scheduledWeekDays.map((x) => x)),
        "rewardIDReferences":
            List<dynamic>.from(rewardIDReferences.map((x) => x)),
        //List<dynamic>.from(rewardIDReferences.map((x) => x.toJson())),
        "trackedCompletions": trackedCompletions.toJson(),
      };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        title: json["title"],
        description: json["description"],
        id: json["id"],
        completionGoal: json["completionGoal"],
        creationDate: DateTime.parse(json["creationDate"]),
        scheduledWeekDays:
            List<int>.from(json["scheduledWeekDays"].map((x) => x)),
        rewardIDReferences:
            List<String>.from(json["rewardIDReferences"].map((x) => x)),
        // List<Reward>.from(
        //     json["rewardIDReferences"].map((x) => Reward.fromJson(x))),
        trackedCompletions:
            TrackedCompletions.fromJson(json["trackedCompletions"]),
      );

  bool isScheduledForToday() {
    bool isScheduledForToday =
        scheduledWeekDays.contains(DateUtilits.today.weekday);
    return isScheduledForToday;
  }

  List<int> _getYearWeekDayIndexList() {
    DateController _dateController = Get.find<DateController>();
    bool isIndexListEmpty = _dateController.todaysYearWeekDayIndexList.isEmpty;
    bool wasUpdatedToday =
        _dateController.indexListLastUpdateDate == DateUtilits.today;

    if (!isIndexListEmpty && wasUpdatedToday) {
      return _dateController.todaysYearWeekDayIndexList;
    }
    _dateController.todaysYearWeekDayIndexList.clear();

    int yearIndex = _getYearIndex();
    _dateController.todaysYearWeekDayIndexList.add(yearIndex);

    int weekIndex = _getCalendarWeekIndex(yearIndex: yearIndex);
    _dateController.todaysYearWeekDayIndexList.add(weekIndex);

    int dayIndex = _getTodaysIndex(yearIndex: yearIndex, weekIndex: weekIndex);
    _dateController.todaysYearWeekDayIndexList.add(dayIndex);

    _dateController.indexListLastUpdateDate = DateUtilits.today;
    return _dateController.todaysYearWeekDayIndexList;
  }

  int _getYearIndex() {
    int _year = DateUtilits.today.year;

    if (!trackedCompletions.trackedYears
        .any((element) => element.yearCount == _year)) {
      trackedCompletions.trackedYears
          .add(Year(yearCount: _year, calendarWeeks: []));
    }

    return trackedCompletions.trackedYears
        .indexWhere((element) => element.yearCount == _year);
  }

  int _getCalendarWeekIndex({int yearIndex}) {
    int _calendarWeek = DateUtilits.currentCalendarWeek;

    if (!trackedCompletions.trackedYears[yearIndex].calendarWeeks
        .any((element) => element.weekNumber == _calendarWeek)) {
      trackedCompletions.trackedYears[yearIndex].calendarWeeks
          .add(CalendarWeek(weekNumber: _calendarWeek, trackedDays: []));
    }

    return trackedCompletions.trackedYears[yearIndex].calendarWeeks
        .indexWhere((element) => element.weekNumber == _calendarWeek);
  }

  int _getTodaysIndex({int yearIndex, int weekIndex}) {
    int _todayCount = DateUtilits.today.day;

    if (!trackedCompletions
        .trackedYears[yearIndex].calendarWeeks[weekIndex].trackedDays
        .any((element) => element.dayCount == _todayCount)) {
      trackedCompletions
          .trackedYears[yearIndex].calendarWeeks[weekIndex].trackedDays
          .add(
        TrackedDay(
          dayCount: _todayCount,
          doneAmount: 0,
          goalAmount: completionGoal,
        ),
      );
    }

    return trackedCompletions
        .trackedYears[yearIndex].calendarWeeks[weekIndex].trackedDays
        .indexWhere((element) => element.dayCount == _todayCount);
  }

  int getTodaysCompletions() {
    List<int> _yearWeekDayIndexList = _getYearWeekDayIndexList();
    print("todaysCompletionsList : $_yearWeekDayIndexList");
    if (_yearWeekDayIndexList == null) return null;

    TrackedDay _trackedToday = trackedCompletions
        .trackedYears[_yearWeekDayIndexList[0]]
        .calendarWeeks[_yearWeekDayIndexList[1]]
        .trackedDays[_yearWeekDayIndexList[2]];

    return _trackedToday.doneAmount;
  }

  bool wasFinishedToday() {
    List<int> _yearWeekDayIndexList = _getYearWeekDayIndexList();
    print("wasFinishedToday : $_yearWeekDayIndexList");
    TrackedDay _trackedToday = trackedCompletions
        .trackedYears[_yearWeekDayIndexList[0]]
        .calendarWeeks[_yearWeekDayIndexList[1]]
        .trackedDays[_yearWeekDayIndexList[2]];
    if (_yearWeekDayIndexList == null) return false;

    bool wasFinishedToday = _trackedToday.doneAmount >= completionGoal;
    return wasFinishedToday;
  }

  void addCompletionForToday({Function onCompletionGoalReached}) {
    List<int> _yearWeekDayIndexList = _getYearWeekDayIndexList();
    print("addCompletionForToday : $_yearWeekDayIndexList");

    if (_yearWeekDayIndexList == null) return;

    trackedCompletions
        .trackedYears[_yearWeekDayIndexList[0]]
        .calendarWeeks[_yearWeekDayIndexList[1]]
        .trackedDays[_yearWeekDayIndexList[2]]
        .doneAmount++;

    if (trackedCompletions
            .trackedYears[_yearWeekDayIndexList[0]]
            .calendarWeeks[_yearWeekDayIndexList[1]]
            .trackedDays[_yearWeekDayIndexList[2]]
            .doneAmount >=
        completionGoal) onCompletionGoalReached();

    Get.find<ContentController>().updateHabit(habitID: id);
  }

  List getCompletionDataForTimeSpan(TimeSpan timeSpan) {
    int year = DateUtilits.today.year;
    int currentYearIndex = trackedCompletions.trackedYears
        .indexWhere((element) => element.yearCount == year);

    switch (timeSpan) {
      case TimeSpan.WEEK:
        int _currentCalendarWeek = DateUtilits.currentCalendarWeek;
        CalendarWeek _currentWeekObject =
            _getCalendarWeekObject(currentYearIndex, _currentCalendarWeek);
        List<TrackedDay> _dayList = _currentWeekObject.trackedDays;

        if (_dayList.length < 7) {
          List<TrackedDay> _filledUpList = [];
          List<int> thisWeeksDates = DateUtilits.getCurrentWeeksDateList();

          for (var i = 0; i < thisWeeksDates.length; i++) {
            TrackedDay _day = _dayList.firstWhere(
                (element) => element.dayCount == thisWeeksDates[i],
                orElse: () => TrackedDay(
                    dayCount: thisWeeksDates[i],
                    doneAmount: 0,
                    goalAmount: completionGoal));
            _filledUpList.insert(i, _day);
          }

          return _filledUpList;
        }
        return _dayList;
        break;

      case TimeSpan.MONTH:

        //TODO: check if last four calendarweeks do not count <1
        //
        List<CalendarWeek> lastFourCalendarWeekObjects = [];
        List<int> lastFourCalendarWeekNumbers =
            DateUtilits.getLastFourCalendarWeeks();

        for (var i = 0; i < lastFourCalendarWeekNumbers.length; i++) {
          CalendarWeek week = _getCalendarWeekObject(
              currentYearIndex, lastFourCalendarWeekNumbers[i]);
          lastFourCalendarWeekObjects.add(week);
        }

        return lastFourCalendarWeekObjects.reversed.toList();
        break;
      case TimeSpan.YEAR:
        break;
      default:
    }
  }

  CalendarWeek _getCalendarWeekObject(int currentYearIndex, int weekNumber) {
    CalendarWeek _calendarWeekObject = trackedCompletions
        .trackedYears[currentYearIndex].calendarWeeks
        .firstWhere(
      (element) => element.weekNumber == weekNumber,
      orElse: () => CalendarWeek(
          trackedDays: List.generate(7,
              (index) => TrackedDay(doneAmount: 0, goalAmount: completionGoal)),
          weekNumber: weekNumber),
    );

    return _calendarWeekObject;
  }
}
