import 'package:Marbit/models/trackedCompletionsModel.dart';
import 'package:Marbit/util/constants.dart';
import 'package:Marbit/util/dateUtilitis.dart';
import 'package:Marbit/models/rewardModel.dart';
import 'package:Marbit/widgets/habitCompletionChart.dart';

class Habit {
  String title;
  String id;
  DateTime creationDate;
  String description;
  List<int> scheduledWeekDays;
  List<Reward> rewardList;
  TrackedCompletions trackedCompletions;
  int completionGoal;

  //TODO: implement color serialization
  Map<String, int> habitColors = {
    "light": kLightOrange.value,
    "deep": kDeepOrange.value
  };

  Habit({
    this.title,
    this.description,
    this.id,
    this.creationDate,
    this.scheduledWeekDays,
    this.rewardList,
    this.trackedCompletions,
    this.completionGoal,
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
        "rewardList": List<dynamic>.from(rewardList.map((x) => x.toJson())),
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
        rewardList: List<Reward>.from(
            json["rewardList"].map((x) => Reward.fromJson(x))),
        trackedCompletions:
            TrackedCompletions.fromJson(json["trackedCompletions"]),
      );

  bool isScheduledForToday() {
    bool isScheduledForToday =
        scheduledWeekDays.contains(DateTime.now().weekday);
    return isScheduledForToday;
  }

  List<int> _getYearWeekDayIndexList() {
    int _year = DateUtilits.today.year;
    int _calendarWeek = DateUtilits.getCurrentCalendarWeek();

    int _todayCount = DateUtilits.today.day;
    List<int> _yearWeekDayIndexList = [];

    int yearIndex = trackedCompletions.trackedYears
        .indexWhere((element) => element.yearCount == _year);
    if (yearIndex == null) return null;
    _yearWeekDayIndexList.add(yearIndex);

    int weekIndex = trackedCompletions.trackedYears[yearIndex].calendarWeeks
        .indexWhere((element) => element.weekNumber == _calendarWeek);
    if (weekIndex == null) return null;
    _yearWeekDayIndexList.add(weekIndex);

    int dayIndex = trackedCompletions
        .trackedYears[yearIndex].calendarWeeks[weekIndex].trackedDays
        .indexWhere((element) => element.dayCount == _todayCount);

    if (dayIndex == null) return null;
    _yearWeekDayIndexList.add(dayIndex);

    return _yearWeekDayIndexList;
  }

  int getTodaysCompletions() {
    List<int> _yearWeekDayIndexList = _getYearWeekDayIndexList();
    if (_yearWeekDayIndexList == null) return null;

    TrackedDay _trackedToday = trackedCompletions
        .trackedYears[_yearWeekDayIndexList[0]]
        .calendarWeeks[_yearWeekDayIndexList[1]]
        .trackedDays[_yearWeekDayIndexList[2]];
    return _trackedToday.doneAmount;
  }

  bool wasFinishedToday() {
    List<int> _yearWeekDayIndexList = _getYearWeekDayIndexList();
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
  }

  List getCompletionDataForTimeSpan(TimeSpan timeSpan) {
    int year = DateUtilits.today.year;
    int currentYearIndex = trackedCompletions.trackedYears
        .indexWhere((element) => element.yearCount == year);

    switch (timeSpan) {
      case TimeSpan.WEEK:
        int _currentWeekNumber = DateUtilits.getCurrentCalendarWeek();

        CalendarWeek week =
            _getCalendarWeek(currentYearIndex, _currentWeekNumber);

        List<TrackedDay> dayList = week.trackedDays;

        return dayList;
        break;
      case TimeSpan.MONTH:
        //TODO: check if last four calendarweeks do not count <1
        List<CalendarWeek> lastFourCalendarWeekObjects = [];
        List<int> lastFourCalendarWeekNumbers =
            DateUtilits.getLastFourCalendarWeeks();

        for (var i = 0; i < lastFourCalendarWeekNumbers.length; i++) {
          CalendarWeek week = _getCalendarWeek(
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

  CalendarWeek _getCalendarWeek(int currentYearIndex, int weekNumber) {
    return trackedCompletions.trackedYears[currentYearIndex].calendarWeeks
        .firstWhere((element) => element.weekNumber == weekNumber);
  }
}
