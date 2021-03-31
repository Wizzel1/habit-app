class TrackedCompletions {
  TrackedCompletions({
    this.trackedYears,
  });

  List<Year> trackedYears;

  factory TrackedCompletions.fromJson(Map<String, dynamic> json) =>
      TrackedCompletions(
        trackedYears:
            List<Year>.from(json["trackedYears"].map((x) => Year.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "trackedYears": List<dynamic>.from(trackedYears.map((x) => x.toJson())),
      };
}

class Year {
  Year({
    this.yearCount,
    this.calendarWeeks,
  });

  int yearCount;
  List<CalendarWeek> calendarWeeks;

  factory Year.fromJson(Map<String, dynamic> json) => Year(
        yearCount: json["yearCount"],
        calendarWeeks: List<CalendarWeek>.from(
            json["calendarWeeks"].map((x) => CalendarWeek.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "yearCount": yearCount,
        "calendarWeeks":
            List<dynamic>.from(calendarWeeks.map((x) => x.toJson())),
      };
}

class CalendarWeek {
  CalendarWeek({
    this.weekNumber,
    this.trackedDays,
  });

  int weekNumber;
  List<TrackedDay> trackedDays;

  factory CalendarWeek.fromJson(Map<String, dynamic> json) => CalendarWeek(
        weekNumber: json["weekNumber"],
        trackedDays: List<TrackedDay>.from(
            json["trackedDays"].map((x) => TrackedDay.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "weekNumber": weekNumber,
        "trackedDays": List<dynamic>.from(trackedDays.map((x) => x.toJson())),
      };
}

class TrackedDay {
  TrackedDay({
    this.dayCount,
    this.goalAmount,
    this.doneAmount,
  });

  int dayCount;
  int goalAmount;
  int doneAmount;

  factory TrackedDay.fromJson(Map<String, dynamic> json) => TrackedDay(
        dayCount: json["dayCount"],
        goalAmount: json["goalAmount"],
        doneAmount: json["doneAmount"],
      );

  Map<String, dynamic> toJson() => {
        "dayCount": dayCount,
        "goalAmount": goalAmount,
        "doneAmount": doneAmount,
      };
}
