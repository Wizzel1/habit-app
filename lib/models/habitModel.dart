import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/models/models.dart';
import 'package:Marbit/util/util.dart';
import 'package:Marbit/widgets/widgets.dart';
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
  DateTime nextCompletionDate;
  int streak;
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
    @required this.nextCompletionDate,
    @required this.trackedCompletions,
    @required this.streak,
    @required this.completionGoal,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "id": id,
        "completionGoal": completionGoal,
        "streak": streak,
        "creationDate":
            "${creationDate.year.toString().padLeft(4, '0')}-${creationDate.month.toString().padLeft(2, '0')}-${creationDate.day.toString().padLeft(2, '0')}",
        "nextCompletionDate":
            "${nextCompletionDate.year.toString().padLeft(4, '0')}-${nextCompletionDate.month.toString().padLeft(2, '0')}-${nextCompletionDate.day.toString().padLeft(2, '0')}",
        "scheduledWeekDays":
            List<dynamic>.from(scheduledWeekDays.map((x) => x)),
        "rewardIDReferences":
            List<dynamic>.from(rewardIDReferences.map((x) => x)),
        "trackedCompletions": trackedCompletions.toJson(),
      };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        title: json["title"],
        description: json["description"],
        id: json["id"],
        streak: json["streak"],
        completionGoal: json["completionGoal"],
        creationDate: DateTime.parse(json["creationDate"]),
        nextCompletionDate: DateTime.parse(json["nextCompletionDate"]),
        scheduledWeekDays:
            List<int>.from(json["scheduledWeekDays"].map((x) => x)),
        rewardIDReferences:
            List<String>.from(json["rewardIDReferences"].map((x) => x)),
        trackedCompletions:
            TrackedCompletions.fromJson(json["trackedCompletions"]),
      );

  bool isScheduledForToday() {
    bool isScheduledForToday =
        scheduledWeekDays.contains(DateUtilities.today.weekday);
    return isScheduledForToday;
  }

  ///Returns a List of Indices. This list leads to the reference of the current Day as TrackedDay if used on "TrackedCompletions".
  //TODO find a way to improve this method
  List<int> _getYearWeekDayIndexList() {
    DateController _dateController = Get.find<DateController>();
    bool isIndexListEmpty = _dateController.todaysYearWeekDayIndexList.isEmpty;
    bool wasUpdatedToday =
        _dateController.indexListLastUpdateDate == DateUtilities.today;

    if (!isIndexListEmpty && wasUpdatedToday) {
      assert(_dateController.todaysYearWeekDayIndexList.length == 3,
          "IndexList has missing indices");
      return _dateController.todaysYearWeekDayIndexList;
    }
    _dateController.todaysYearWeekDayIndexList.clear();

    int yearIndex = _getYearIndex();
    _dateController.todaysYearWeekDayIndexList.add(yearIndex);

    int weekIndex = _getCalendarWeekIndex(yearIndex: yearIndex);
    _dateController.todaysYearWeekDayIndexList.add(weekIndex);

    int dayIndex = _getTodaysIndex(yearIndex: yearIndex, weekIndex: weekIndex);
    _dateController.todaysYearWeekDayIndexList.add(dayIndex);

    _dateController.indexListLastUpdateDate = DateUtilities.today;
    assert(_dateController.todaysYearWeekDayIndexList.length == 3,
        "IndexList has missing indices");

    return _dateController.todaysYearWeekDayIndexList;
  }

  int _getYearIndex() {
    int _year = DateUtilities.today.year;

    if (!trackedCompletions.trackedYears
        .any((element) => element.yearCount == _year)) {
      trackedCompletions.trackedYears
          .add(Year(yearCount: _year, calendarWeeks: []));
    }
    int _yearIndex = trackedCompletions.trackedYears
        .indexWhere((element) => element.yearCount == _year);

    assert(_yearIndex >= 0, "YearIndex must not be negative");
    return _yearIndex;
  }

  int _getCalendarWeekIndex({int yearIndex}) {
    int _calendarWeek = DateUtilities.currentCalendarWeek;

    if (!trackedCompletions.trackedYears[yearIndex].calendarWeeks
        .any((element) => element.weekNumber == _calendarWeek)) {
      trackedCompletions.trackedYears[yearIndex].calendarWeeks
          .add(CalendarWeek(weekNumber: _calendarWeek, trackedDays: []));
    }

    int _calendarWeekIndex = trackedCompletions
        .trackedYears[yearIndex].calendarWeeks
        .indexWhere((element) => element.weekNumber == _calendarWeek);

    assert(_calendarWeekIndex >= 0, "CalendarWeekIndex must not be negative");
    return _calendarWeekIndex;
  }

  int _getTodaysIndex({int yearIndex, int weekIndex}) {
    int _todayCount = DateUtilities.today.day;

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

    int _todaysIndex = trackedCompletions
        .trackedYears[yearIndex].calendarWeeks[weekIndex].trackedDays
        .indexWhere((element) => element.dayCount == _todayCount);

    assert(_todaysIndex >= 0, "Todays Index must not be negative");
    return _todaysIndex;
  }

  int getTodaysCompletions() {
    List<int> _yearWeekDayIndexList = _getYearWeekDayIndexList();
    print("todaysCompletionsList : $_yearWeekDayIndexList");

    if (_yearWeekDayIndexList == null) return null;

    int _yearIndex = _yearWeekDayIndexList[0];
    int _calendarWeekIndex = _yearWeekDayIndexList[1];
    int _trackedDayIndex = _yearWeekDayIndexList[2];

    TrackedDay _trackedToday = trackedCompletions.trackedYears[_yearIndex]
        .calendarWeeks[_calendarWeekIndex].trackedDays[_trackedDayIndex];

    return _trackedToday.doneAmount;
  }

  bool wasFinishedToday() {
    List<int> _yearWeekDayIndexList = _getYearWeekDayIndexList();
    print("wasFinishedToday : $_yearWeekDayIndexList");

    if (_yearWeekDayIndexList == null) return false;

    int _yearIndex = _yearWeekDayIndexList[0];
    int _calendarWeekIndex = _yearWeekDayIndexList[1];
    int _trackedDayIndex = _yearWeekDayIndexList[2];

    TrackedDay _trackedToday = trackedCompletions.trackedYears[_yearIndex]
        .calendarWeeks[_calendarWeekIndex].trackedDays[_trackedDayIndex];

    bool wasFinishedToday = _trackedToday.doneAmount >= completionGoal;
    return wasFinishedToday;
  }

  void addCompletionForToday({Function onCompletionGoalReached}) {
    List<int> _yearWeekDayIndexList = _getYearWeekDayIndexList();
    print("addCompletionForToday : $_yearWeekDayIndexList");

    if (_yearWeekDayIndexList == null) return;

    int _yearIndex = _yearWeekDayIndexList[0];
    int _calendarWeekIndex = _yearWeekDayIndexList[1];
    int _trackedDayIndex = _yearWeekDayIndexList[2];

    _updateCompletionStreak();

    trackedCompletions
        .trackedYears[_yearIndex]
        .calendarWeeks[_calendarWeekIndex]
        .trackedDays[_trackedDayIndex]
        .doneAmount++;

    if (trackedCompletions
            .trackedYears[_yearIndex]
            .calendarWeeks[_calendarWeekIndex]
            .trackedDays[_trackedDayIndex]
            .doneAmount >=
        completionGoal) {
      onCompletionGoalReached();
      Get.find<ContentController>().reloadHabitList();
    }

    Get.find<EditContentController>().updateHabit(id);
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
    int year = DateUtilities.today.year;
    int currentYearIndex = trackedCompletions.trackedYears
        .indexWhere((element) => element.yearCount == year);

    switch (timeSpan) {
      case TimeSpan.WEEK:
        int _currentCalendarWeek = DateUtilities.currentCalendarWeek;
        CalendarWeek _currentWeekObject =
            _getCalendarWeekObject(currentYearIndex, _currentCalendarWeek);
        List<TrackedDay> _dayList = _currentWeekObject.trackedDays;

        if (_dayList.length < 7) {
          List<TrackedDay> _filledUpList = [];
          List<int> thisWeeksDates = DateUtilities.getCurrentWeeksDateList();

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
            DateUtilities.getLastFourCalendarWeeks();

        for (var i = 0; i < lastFourCalendarWeekNumbers.length; i++) {
          CalendarWeek week = _getCalendarWeekObject(
              currentYearIndex, lastFourCalendarWeekNumbers[i]);
          lastFourCalendarWeekObjects.add(week);
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

  CalendarWeek _getCalendarWeekObject(int currentYearIndex, int weekNumber) {
    CalendarWeek _calendarWeekObject = trackedCompletions
        .trackedYears[currentYearIndex].calendarWeeks
        .firstWhere(
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
