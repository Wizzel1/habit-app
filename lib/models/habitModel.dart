import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/util/util.dart';
import 'package:Marbit/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Habit {
  /// The Title of the Habit.
  String title;

  /// The uuid of the Habit.
  String id;

  /// A counting number that is used as prefix for the Habit's [NotificationObject]s.
  int notificationIDprefix;

  /// The optional Description.
  String description;

  /// The scheduled Weekdays (1-7).
  List<int> scheduledWeekDays;

  /// The references to this Habit's [Reward]s.
  List<String> rewardIDReferences;

  /// The Datastructure that holds completiondata about this Habit.
  TrackedCompletions trackedCompletions;

  /// The Date of the next scheduled Weekday.
  DateTime nextCompletionDate;

  /// The current completionstreak.
  int streak;

  /// The daily completiongoal.
  int completionGoal;

  /// The list of [NotificationObject]s, based on the Habit's current Schedule.
  List<NotificationObject> notificationObjects;

  //TODO: implement color serialization
  Map<String, int> habitColors = {
    "light": kLightOrange.value,
    "deep": kDeepOrange.value
  };

  Habit(
      {@required this.title,
      @required this.description,
      @required this.id,
      @required this.notificationIDprefix,
      @required this.scheduledWeekDays,
      @required this.rewardIDReferences,
      @required this.nextCompletionDate,
      @required this.trackedCompletions,
      @required this.streak,
      @required this.completionGoal,
      @required this.notificationObjects});

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "id": id,
        "notificationIDprefix": notificationIDprefix,
        "completionGoal": completionGoal,
        "streak": streak,
        "nextCompletionDate":
            "${nextCompletionDate.year.toString().padLeft(4, '0')}-${nextCompletionDate.month.toString().padLeft(2, '0')}-${nextCompletionDate.day.toString().padLeft(2, '0')}",
        "scheduledWeekDays":
            List<dynamic>.from(scheduledWeekDays.map((x) => x)),
        "rewardIDReferences":
            List<dynamic>.from(rewardIDReferences.map((x) => x)),
        "trackedCompletions": trackedCompletions.toJson(),
        "notificationObjects":
            List<dynamic>.from(notificationObjects.map((x) => x.toJson())),
      };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        title: json["title"],
        description: json["description"],
        id: json["id"],
        notificationIDprefix: json["notificationIDprefix"],
        streak: json["streak"],
        completionGoal: json["completionGoal"],
        nextCompletionDate: DateTime.parse(json["nextCompletionDate"]),
        scheduledWeekDays:
            List<int>.from(json["scheduledWeekDays"].map((x) => x)),
        rewardIDReferences:
            List<String>.from(json["rewardIDReferences"].map((x) => x)),
        trackedCompletions:
            TrackedCompletions.fromJson(json["trackedCompletions"]),
        notificationObjects: List<NotificationObject>.from(
            json["notificationObjects"]
                .map((x) => NotificationObject.fromJson(x))),
      );

  bool isScheduledForToday() {
    bool isScheduledForToday =
        scheduledWeekDays.contains(DateUtilities.today.weekday);
    return isScheduledForToday;
  }

  ///Returns a List of Indices. This list leads to the reference of the current Day as TrackedDay if used on "TrackedCompletions".
  //TODO find a way to improve this method
  List<int> _getYearWeekDayIndexList() {
    final DateController _dateController = Get.find<DateController>();
    final bool isIndexListEmpty =
        _dateController.todaysYearWeekDayIndexList.isEmpty;
    final bool wasUpdatedToday =
        _dateController.indexListLastUpdateDate == DateUtilities.today;

    if (!isIndexListEmpty && wasUpdatedToday) {
      assert(_dateController.todaysYearWeekDayIndexList.length == 3,
          "IndexList has missing indices");
      return _dateController.todaysYearWeekDayIndexList;
    }
    _dateController.todaysYearWeekDayIndexList.clear();

    final int yearIndex = _getYearIndex();
    _dateController.todaysYearWeekDayIndexList.add(yearIndex);

    final int weekIndex = _getCalendarWeekIndex(yearIndex: yearIndex);
    _dateController.todaysYearWeekDayIndexList.add(weekIndex);

    final int dayIndex =
        _getTodaysIndex(yearIndex: yearIndex, weekIndex: weekIndex);
    _dateController.todaysYearWeekDayIndexList.add(dayIndex);

    _dateController.indexListLastUpdateDate = DateUtilities.today;
    assert(_dateController.todaysYearWeekDayIndexList.length == 3,
        "IndexList has missing indices");

    return _dateController.todaysYearWeekDayIndexList;
  }

  int _getYearIndex() {
    final int _year = DateUtilities.today.year;

    if (!trackedCompletions.trackedYears
        .any((element) => element.yearCount == _year)) {
      trackedCompletions.trackedYears
          .add(Year(yearCount: _year, calendarWeeks: []));
    }
    final int _yearIndex = trackedCompletions.trackedYears
        .indexWhere((element) => element.yearCount == _year);

    assert(_yearIndex >= 0, "YearIndex must not be negative");
    return _yearIndex;
  }

  int _getCalendarWeekIndex({int yearIndex}) {
    final int _calendarWeek = DateUtilities.currentCalendarWeek;

    if (!trackedCompletions.trackedYears[yearIndex].calendarWeeks
        .any((element) => element.weekNumber == _calendarWeek)) {
      trackedCompletions.trackedYears[yearIndex].calendarWeeks
          .add(CalendarWeek(weekNumber: _calendarWeek, trackedDays: []));
    }

    final int _calendarWeekIndex = trackedCompletions
        .trackedYears[yearIndex].calendarWeeks
        .indexWhere((element) => element.weekNumber == _calendarWeek);

    assert(_calendarWeekIndex >= 0, "CalendarWeekIndex must not be negative");
    return _calendarWeekIndex;
  }

  int _getTodaysIndex({int yearIndex, int weekIndex}) {
    final int _todayCount = DateUtilities.today.day;

    if (!trackedCompletions
        .trackedYears[yearIndex].calendarWeeks[weekIndex].trackedDays
        .any((element) => element.dayCount == _todayCount)) {
      trackedCompletions
          .trackedYears[yearIndex].calendarWeeks[weekIndex].trackedDays
          .add(TrackedDay(
              dayCount: _todayCount,
              doneAmount: 0,
              goalAmount: completionGoal));
    }

    final int _todaysIndex = trackedCompletions
        .trackedYears[yearIndex].calendarWeeks[weekIndex].trackedDays
        .indexWhere((element) => element.dayCount == _todayCount);

    assert(_todaysIndex >= 0, "Todays Index must not be negative");
    return _todaysIndex;
  }

  int getTodaysCompletions() {
    final List<int> _yearWeekDayIndexList = _getYearWeekDayIndexList();
    print("todaysCompletionsList : $_yearWeekDayIndexList");

    if (_yearWeekDayIndexList == null) return null;

    final int _yearIndex = _yearWeekDayIndexList[0];
    final int _calendarWeekIndex = _yearWeekDayIndexList[1];
    final int _trackedDayIndex = _yearWeekDayIndexList[2];

    final TrackedDay _trackedToday = trackedCompletions.trackedYears[_yearIndex]
        .calendarWeeks[_calendarWeekIndex].trackedDays[_trackedDayIndex];

    return _trackedToday.doneAmount;
  }

  bool wasFinishedToday() {
    final List<int> _yearWeekDayIndexList = _getYearWeekDayIndexList();
    print("wasFinishedToday : $_yearWeekDayIndexList");

    if (_yearWeekDayIndexList == null) return false;

    final int _yearIndex = _yearWeekDayIndexList[0];
    final int _calendarWeekIndex = _yearWeekDayIndexList[1];
    final int _trackedDayIndex = _yearWeekDayIndexList[2];

    final TrackedDay _trackedToday = trackedCompletions.trackedYears[_yearIndex]
        .calendarWeeks[_calendarWeekIndex].trackedDays[_trackedDayIndex];

    final bool wasFinishedToday = _trackedToday.doneAmount >= completionGoal;
    return wasFinishedToday;
  }

  Future<void> addCompletionForToday({Function onCompletionGoalReached}) async {
    final List<int> _yearWeekDayIndexList = _getYearWeekDayIndexList();
    print("addCompletionForToday : $_yearWeekDayIndexList");

    if (_yearWeekDayIndexList == null) return;

    final int _yearIndex = _yearWeekDayIndexList[0];
    final int _calendarWeekIndex = _yearWeekDayIndexList[1];
    final int _trackedDayIndex = _yearWeekDayIndexList[2];

    _updateCompletionStreak();

    trackedCompletions
        .trackedYears[_yearIndex]
        .calendarWeeks[_calendarWeekIndex]
        .trackedDays[_trackedDayIndex]
        .doneAmount++;

    await _checkRelatedNotificationForRescheduling(trackedCompletions
        .trackedYears[_yearIndex]
        .calendarWeeks[_calendarWeekIndex]
        .trackedDays[_trackedDayIndex]
        .doneAmount);

    if (wasFinishedToday()) {
      onCompletionGoalReached();
      Get.find<ContentController>().reloadHabitList();
    }

    Get.find<EditContentController>().updateHabit(id);
  }

  Future<void> _checkRelatedNotificationForRescheduling(
      int completionStep) async {
    final NotificationObject _relatedNotification =
        _identifyStepRelatedNotification(completionStep);

    if (_relatedNotification == null) return;

    await Get.find<NotifyController>()
        .checkAndHandleNotificationRescheduling(_relatedNotification);
  }

  NotificationObject _identifyStepRelatedNotification(int completionStep) {
    assert(completionStep > 0, "completionStep parameter must not be negative");
    assert(completionStep <= ContentController.maxDailyCompletions,
        "completionStep must not be greater than the max completion goal");

    return notificationObjects.firstWhere(
        (element) =>
            element.weekDay == DateUtilities.today.weekday &&
            element.relatedCompletionStep == completionStep,
        orElse: () => null);
  }

  void _updateCompletionStreak() {
    if (getTodaysCompletions() > 0) return;
    if (DateUtilities.today == nextCompletionDate) {
      streak++;
    } else {
      streak = 0;
    }
  }

  void updateToNextCompletionDate() {
    int newCompletionWeekDay;

    if (wasFinishedToday()) {
      newCompletionWeekDay = scheduledWeekDays.firstWhere(
          (element) => element > DateUtilities.today.weekday,
          orElse: () => scheduledWeekDays.first);
      if (newCompletionWeekDay == DateUtilities.today.weekday) {
        Get.find<EditContentController>().newCompletionDate.value =
            DateUtilities.today.add(Duration(days: 7));
      } else {
        Get.find<EditContentController>().newCompletionDate.value =
            DateUtilities.getDateTimeOfNextWeekDayOccurrence(
                newCompletionWeekDay);
      }
    } else {
      newCompletionWeekDay = scheduledWeekDays.firstWhere(
          (element) => element >= DateUtilities.today.weekday,
          orElse: () => scheduledWeekDays.first);

      Get.find<EditContentController>().newCompletionDate.value =
          DateUtilities.getDateTimeOfNextWeekDayOccurrence(
              newCompletionWeekDay);
    }
  }

  List getCompletionDataForTimeSpan(TimeSpan timeSpan) {
    final int year = DateUtilities.today.year;
    final int currentYearIndex = trackedCompletions.trackedYears
        .indexWhere((element) => element.yearCount == year);
    int lastYearIndex = trackedCompletions.trackedYears
        .indexWhere((element) => element.yearCount == year - 1);
    if (lastYearIndex < 0) lastYearIndex = null;

    switch (timeSpan) {
      case TimeSpan.WEEK:
        final int _currentCalendarWeek = DateUtilities.currentCalendarWeek;
        final CalendarWeek _currentWeekObject =
            _getCalendarWeekObject(currentYearIndex, _currentCalendarWeek);
        final List<TrackedDay> _dayList = _currentWeekObject.trackedDays;

        if (_dayList.length < 7) {
          List<TrackedDay> _filledUpList = [];
          final List<int> thisWeeksDates =
              DateUtilities.getCurrentWeeksDateList();

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
        List<CalendarWeek> lastFourCalendarWeekObjects = [];
        final List<int> lastFourCalendarWeekNumbers =
            DateUtilities.getLastFourCalendarWeeks();
        final int _lastWeek = DateUtilities.currentCalendarWeek - 1;

        //TODO: debug
        for (var i = 0; i < lastFourCalendarWeekNumbers.length; i++) {
          final bool _isWeekOfLastYear =
              lastFourCalendarWeekNumbers[i] > _lastWeek;

          if (_isWeekOfLastYear) {
            final CalendarWeek week = _getCalendarWeekObject(
                lastYearIndex, lastFourCalendarWeekNumbers[i]);
            lastFourCalendarWeekObjects.add(week);
          } else {
            final CalendarWeek week = _getCalendarWeekObject(
                currentYearIndex, lastFourCalendarWeekNumbers[i]);
            lastFourCalendarWeekObjects.add(week);
          }
        }
        assert(lastFourCalendarWeekNumbers.length == 4,
            "Returned ${lastFourCalendarWeekNumbers.length} WeekObjects");
        return lastFourCalendarWeekObjects.reversed.toList();
        break;
      case TimeSpan.YEAR:
        break;
      default:
    }
  }

  CalendarWeek _getCalendarWeekObject(int yearIndex, int weekNumber) {
    final CalendarWeek _calendarWeekObject =
        trackedCompletions.trackedYears[yearIndex].calendarWeeks.firstWhere(
      (element) => element.weekNumber == weekNumber,
      orElse: () => CalendarWeek(
          trackedDays: List.generate(
            7,
            (index) => TrackedDay(doneAmount: 0, goalAmount: completionGoal),
          ),
          weekNumber: weekNumber),
    );
    assert(_calendarWeekObject.trackedDays.length <= 7,
        "The returned calendarweekobject had ${_calendarWeekObject.trackedDays.length} tracked days");
    return _calendarWeekObject;
  }
}
