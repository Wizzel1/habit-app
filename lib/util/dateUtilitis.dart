import 'dart:math';

import 'package:Marbit/models/trackedCompletionsModel.dart';
import 'package:intl/intl.dart';
import 'package:week_of_year/week_of_year.dart';

class DateUtilits {
  static final DateFormat formatter = DateFormat("yyyy-MM-dd");

  //TODO replace with datetime now
  static final DateTime today = DateTime.parse("2021-03-01");

  static int get currentCalendarWeek {
    return today.weekOfYear;
  }

  static List<int> getCurrentWeeksDates() {
    int _weekDay = today.weekday;
    DateTime _monday = today.subtract(Duration(days: _weekDay - 1));
    List<int> _thisWeeksDates = [];

    for (var i = 0; i < 7; i++) {
      int _dayCount = _monday.add(Duration(days: i)).day;
      _thisWeeksDates.add(_dayCount);
    }

    return _thisWeeksDates;
  }

  static List<int> getLastFourCalendarWeeks() {
    int thisWeek = currentCalendarWeek;
    List<int> lastFourCalendarWeeks = [];

    if (thisWeek > 4) {
      for (var i = 0; i < 4; i++) {
        lastFourCalendarWeeks.add(thisWeek - i);
      }
    }
    return lastFourCalendarWeeks;
  }

  static TrackedCompletions get2021ExampleCompletions() {
    DateTime firstDayOf2021 = DateTime.parse("2021-01-04");
    DateTime lastDayOf2021 = DateTime.parse("2021-12-31");

    TrackedCompletions exampleCompletions =
        TrackedCompletions(trackedYears: []);
    Year exampleYear = Year(yearCount: 2021, calendarWeeks: []);
    int dayIndex = 1;
    int weekIndex = 1;

    CalendarWeek _currentWeek = CalendarWeek(weekNumber: 1, trackedDays: []);

    while (firstDayOf2021.isBefore(lastDayOf2021)) {
      TrackedDay _newDay = TrackedDay(
          dayCount: firstDayOf2021.day, doneAmount: 0, goalAmount: 7);
      _currentWeek.trackedDays.add(_newDay);

      if (dayIndex % 7 == 0) {
        exampleYear.calendarWeeks.add(_currentWeek);
        weekIndex++;
        _currentWeek = CalendarWeek(weekNumber: weekIndex, trackedDays: []);
      }
      dayIndex++;
      firstDayOf2021 = firstDayOf2021.add(Duration(days: 1));
    }

    TrackedDay lastDay =
        TrackedDay(dayCount: lastDayOf2021.day, doneAmount: 2, goalAmount: 3);
    exampleYear.calendarWeeks.last.trackedDays.add(lastDay);

    exampleCompletions.trackedYears.add(exampleYear);

    return exampleCompletions;
  }
}
