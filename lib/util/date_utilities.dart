// ignore_for_file: avoid_classes_with_only_static_members

import 'package:Marbit/models/models.dart';
import 'package:intl/intl.dart';
import 'package:week_of_year/week_of_year.dart';

class DateUtilities {
  static final DateFormat formatter = DateFormat("yyyy-MM-dd");

  static final DateTime today =
      DateTime.parse(formatter.format(DateTime.now()));

  static int get currentCalendarWeek {
    return today.weekOfYear;
  }

  static List<int> getCurrentWeeksDateList() {
    final int _weekDay = today.weekday;
    final DateTime _thisMonday = today.subtract(Duration(days: _weekDay - 1));
    final List<int> _thisWeeksDates = [];

    for (var i = 0; i < 7; i++) {
      final int _dayCount = _thisMonday.add(Duration(days: i)).day;
      _thisWeeksDates.add(_dayCount);
    }
    assert(_thisWeeksDates.length == 7,
        "_thisWeeksDates has length ${_thisWeeksDates.length}");
    return _thisWeeksDates;
  }

  static List<int?> getLastFourCalendarWeeks() {
    final int _lastWeek = currentCalendarWeek - 1;
    final bool _needsWeeksFromLastYear = _lastWeek < 4;
    final List<int?> _lastFourCalendarWeeks = [];
    int? _lastCalendarWeekLastYear;
    //TODO debug

    if (_needsWeeksFromLastYear) {
      final DateTime _firstDayThisYear = DateTime.parse("${today.year}-01-01");
      DateTime _lastDayLastYear =
          _firstDayThisYear.subtract(const Duration(days: 1));
      _lastCalendarWeekLastYear = _lastDayLastYear.weekOfYear;
      while (
          _lastCalendarWeekLastYear != 53 || _lastCalendarWeekLastYear != 52) {
        _lastDayLastYear = _lastDayLastYear.subtract(const Duration(days: 1));
        _lastCalendarWeekLastYear = _lastDayLastYear.weekOfYear;
      }
    }

    for (var i = 0; i < 4; i++) {
      int? _newWeekNumber;
      final int _weekToAdd = _lastWeek - i;
      if (_weekToAdd >= 1) _newWeekNumber = _weekToAdd;
      if (_weekToAdd < 1) {
        _newWeekNumber = _lastCalendarWeekLastYear! - _weekToAdd.abs();
      }
      _lastFourCalendarWeeks.add(_newWeekNumber);
    }

    assert(_lastFourCalendarWeeks.length == 4,
        "LastfourCalendarWeeks has length ${_lastFourCalendarWeeks.length}");
    return _lastFourCalendarWeeks;
  }

  static DateTime getDateTimeOfNextWeekDayOccurrence(int nextScheduledWeekDay) {
    DateTime _loopingDate = DateUtilities.today;

    for (var i = 0; i < 8; i++) {
      final bool loopingDayIsScheduledDay =
          _loopingDate.weekday == nextScheduledWeekDay;

      if (loopingDayIsScheduledDay) return _loopingDate;

      _loopingDate = _loopingDate.add(const Duration(days: 1));
    }
    return DateTime.now();
  }

  static TrackedCompletions get2021ExampleCompletions() {
    DateTime _firstDayOf2021 = DateTime.parse("2021-01-04");
    final DateTime _lastDayOf2021 = DateTime.parse("2021-12-31");

    final TrackedCompletions exampleCompletions =
        TrackedCompletions(trackedYears: []);
    final Year exampleYear = Year(yearCount: 2021, calendarWeeks: []);
    int dayIndex = 1;
    int weekIndex = 1;

    CalendarWeek _currentWeek = CalendarWeek(weekNumber: 1, trackedDays: []);

    while (_firstDayOf2021.isBefore(_lastDayOf2021)) {
      final TrackedDay _newDay = TrackedDay(
          dayCount: _firstDayOf2021.day, doneAmount: 0, goalAmount: 7);
      _currentWeek.trackedDays!.add(_newDay);

      if (dayIndex % 7 == 0) {
        exampleYear.calendarWeeks!.add(_currentWeek);
        weekIndex++;
        _currentWeek = CalendarWeek(weekNumber: weekIndex, trackedDays: []);
      }
      dayIndex++;
      _firstDayOf2021 = _firstDayOf2021.add(const Duration(days: 1));
    }

    final TrackedDay lastDay =
        TrackedDay(dayCount: _lastDayOf2021.day, doneAmount: 2, goalAmount: 3);
    exampleYear.calendarWeeks!.last.trackedDays!.add(lastDay);

    exampleCompletions.trackedYears!.add(exampleYear);

    return exampleCompletions;
  }
}
