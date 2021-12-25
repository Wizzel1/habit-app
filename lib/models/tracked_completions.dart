class TrackedCompletions {
  TrackedCompletions({
    this.trackedYears,
  });

  List<Year>? trackedYears = [];

  factory TrackedCompletions.fromJson(Map<String, dynamic> json) =>
      TrackedCompletions(
        trackedYears: List<Year>.from(json["trackedYears"]
            .map((Map<String, dynamic> x) => Year.fromJson(x)) as List),
      );

  Map<String, dynamic> toJson() => {
        "trackedYears": List<dynamic>.from(trackedYears!.map((x) => x.toJson())),
      };
}

class Year {
  Year({
    this.yearCount,
    this.calendarWeeks,
  });

  int? yearCount;
  List<CalendarWeek>? calendarWeeks = [];

  factory Year.fromJson(Map<String, dynamic> json) => Year(
        yearCount: json["yearCount"] as int?,
        calendarWeeks: List<CalendarWeek>.from(json["calendarWeeks"]
            .map((Map<String, dynamic> x) => CalendarWeek.fromJson(x)) as List),
      );

  Map<String, dynamic> toJson() => {
        "yearCount": yearCount,
        "calendarWeeks":
            List<dynamic>.from(calendarWeeks!.map((x) => x.toJson())),
      };
}

class CalendarWeek {
  CalendarWeek({
    this.weekNumber,
    this.trackedDays,
  });

  int? weekNumber;
  List<TrackedDay>? trackedDays = [];

  factory CalendarWeek.fromJson(Map<String, dynamic> json) => CalendarWeek(
        weekNumber: json["weekNumber"] as int?,
        trackedDays: List<TrackedDay>.from(json["trackedDays"]
            .map((Map<String, dynamic> x) => TrackedDay.fromJson(x)) as List),
      );

  Map<String, dynamic> toJson() => {
        "weekNumber": weekNumber,
        "trackedDays": List<dynamic>.from(trackedDays!.map((x) => x.toJson())),
      };
}

class TrackedDay {
  TrackedDay({
    this.dayCount,
    this.goalAmount,
    this.doneAmount,
  });

  int? dayCount;
  int? goalAmount;
  int? doneAmount;

  factory TrackedDay.fromJson(Map<String, dynamic> json) => TrackedDay(
        dayCount: json["dayCount"] as int?,
        goalAmount: json["goalAmount"] as int?,
        doneAmount: json["doneAmount"] as int?,
      );

  Map<String, dynamic> toJson() => {
        "dayCount": dayCount,
        "goalAmount": goalAmount,
        "doneAmount": doneAmount,
      };
}
