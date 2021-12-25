import 'package:Marbit/models/models.dart';
import 'package:Marbit/screens/screens.dart';
import 'package:Marbit/util/util.dart';
import 'package:Marbit/widgets/widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

enum TimeSpan { week, month, year }

class HabitCompletionChart extends StatefulWidget {
  final Habit? habit;

  const HabitCompletionChart({Key? key, this.habit}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HabitCompletionChartState();
}

class HabitCompletionChartState extends State<HabitCompletionChart> {
  final Color barBackgroundColor = kLightOrange;
  final Color barColor = kDeepOrange;
  final Color elementColor = kBackGroundWhite;
  final Duration animDuration = const Duration(milliseconds: 100);
  int? _touchedIndex;
  double _maxBarValue = 0;
  TimeSpan _timeSpan = TimeSpan.week;
  List _data = [];
  double? _sideTileInterval;

  List<TrackedDay>? _weekData;
  List<CalendarWeek>? _monthData;
  List<CalendarWeek>? _yearData;

  void _updateData() {
    _data = widget.habit!.getCompletionDataForTimeSpan(_timeSpan);
  }

  Row _buildTimespanButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        NeumorphPressSwitch(
          onPressed: () {
            setState(() {
              _maxBarValue = 0;
              _timeSpan = TimeSpan.week;
              _updateData();
            });
          },
          style: _timeSpan == TimeSpan.week
              ? kActiveNeumorphStyle
              : kInactiveNeumorphStyle,
          child: Text(
            'this_week'.tr,
            style: Theme.of(context).textTheme.button!.copyWith(
                fontSize: 12,
                color: _timeSpan == TimeSpan.week
                    ? kBackGroundWhite
                    : kDeepOrange),
          ),
        ),
        NeumorphPressSwitch(
          onPressed: () {
            setState(() {
              _maxBarValue = 0;
              _timeSpan = TimeSpan.month;
              _updateData();
            });
          },
          style: _timeSpan == TimeSpan.month
              ? kActiveNeumorphStyle
              : kInactiveNeumorphStyle,
          child: Text(
            'last_four_weeks'.tr,
            style: Theme.of(context).textTheme.button!.copyWith(
                  fontSize: 12,
                  color: _timeSpan == TimeSpan.month
                      ? kBackGroundWhite
                      : kDeepOrange,
                ),
          ),
        ),

        // MaterialButton(
        //   onPressed: () {
        //     setState(() {
        //       _maxBarValue = 0;
        //       _timeSpan = TimeSpan.YEAR;
        //     _updateData();
        //     });
        //   },
        //   elevation: 0,
        //   shape:
        //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //   color: kBackGroundWhite,
        //   child: Text(
        //     "This Year",
        //     style: Theme.of(context).textTheme.button.copyWith(
        //         fontSize: 12, color: Color(widget.habit.habitColors["deep"])),
        //   ),
        // )
      ],
    );
  }

  @override
  void initState() {
    _updateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // aspectRatio: 1.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(child: _buildTimespanButtonRow()),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: const Offset(3, 3),
                      blurRadius: 3)
                ],
                color: elementColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(
                      height: 12,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: BarChart(
                          mainBarData(),
                          swapAnimationDuration: animDuration,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int horizontalIndex,
    double value, {
    bool isTouched = false,
    Color barColor = kDeepOrange,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: horizontalIndex,
      barRods: [
        BarChartRodData(
          y: isTouched ? value : value,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          colors: isTouched ? [kBackGroundWhite] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: _maxBarValue,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> getGroupData() {
    final List<BarChartGroupData> _dataList = [];

    switch (_timeSpan) {
      case TimeSpan.week:
        _weekData ??= _data as List<TrackedDay>;

        assert(
            _weekData!.length == 7, "WeekData length was ${_weekData!.length}");

        for (var i = 0; i < _weekData!.length; i++) {
          final TrackedDay day = _weekData![i];
          if (_maxBarValue != widget.habit!.completionGoal) {
            _maxBarValue = widget.habit!.completionGoal!.toDouble();
          }

          _dataList.add(makeGroupData(i, day.doneAmount!.toDouble(),
              isTouched: i == _touchedIndex));
        }

        return _dataList;
        break;
      case TimeSpan.month:
        _monthData ??= _data as List<CalendarWeek>;

        assert(_monthData!.length == 4,
            "Monthdata length was ${_monthData!.length}");

        for (var i = 0; i < _monthData!.length; i++) {
          final List<TrackedDay> _daylist = _monthData![i].trackedDays!;
          double _completions = 0;

          for (final TrackedDay _day in _daylist) {
            _completions += _day.doneAmount!;
          }

          _maxBarValue = (widget.habit!.completionGoal! *
                  widget.habit!.scheduledWeekDays.length)
              .toDouble();

          _dataList.add(
              makeGroupData(i, _completions, isTouched: i == _touchedIndex));
        }
        return _dataList;
        break;
      case TimeSpan.year:
        return _dataList;
        break;
    }
    return [];
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: kBackGroundWhite,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final int index = group.x.toInt();
              switch (_timeSpan) {
                case TimeSpan.week:
                  String? weekDay;
                  if ((index + 1) == DateUtilities.today.weekday) {
                    weekDay = 'today'.tr;
                    return _createTooltipItemForDay(weekDay, rod);
                  }
                  switch (index) {
                    case 0:
                      weekDay = 'monday'.tr;
                      break;
                    case 1:
                      weekDay = 'tuesday'.tr;
                      break;
                    case 2:
                      weekDay = 'wednesday'.tr;
                      break;
                    case 3:
                      weekDay = 'thursday'.tr;
                      break;
                    case 4:
                      weekDay = 'friday'.tr;
                      break;
                    case 5:
                      weekDay = 'saturday'.tr;
                      break;
                    case 6:
                      weekDay = 'sunday'.tr;
                      break;
                  }
                  return _createTooltipItemForDay(weekDay, rod);
                  break;
                case TimeSpan.month:
                  String weekNumber;

                  weekNumber = '${_monthData![index].weekNumber}';
                  return _createTooltipItemForWeek(weekNumber, rod);

                  break;
                case TimeSpan.year:
                  break;
              }
            }),
        touchCallback: (touchEvent, barTouchResponse) {
          setState(() {
            if (barTouchResponse!.spot != null &&
                touchEvent is! PointerUpEvent &&
                touchEvent is! PointerExitEvent) {
              _touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
            } else {
              _touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value, _) =>
              Theme.of(context).textTheme.caption!.copyWith(color: kDeepOrange),
          margin: 16,
          getTitles: (double value) {
            final int _value = value.toInt();
            switch (_timeSpan) {
              case TimeSpan.week:
                return dayNames[_value];
                break;
              case TimeSpan.month:
                if (_value < 4) {
                  return _monthData![_value].weekNumber.toString();
                }
                break;
              case TimeSpan.year:
                break;
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          interval: _calculateInterval(),
          getTextStyles: (value, _) =>
              Theme.of(context).textTheme.caption!.copyWith(color: kDeepOrange),
          margin: 16,
          showTitles: true,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: getGroupData(),
    );
  }

  double _calculateInterval() {
    final int _scheduledDays = widget.habit!.scheduledWeekDays.length;
    final int _completionGoal = widget.habit!.completionGoal!;

    final int _max = _scheduledDays * _completionGoal;
    for (var i = 7.0; i >= 0.0; i--) {
      if (_max % i == 0) {
        return i;
      }
    }
    return 0;
  }

  BarTooltipItem _createTooltipItemForWeek(
      String weekNumber, BarChartRodData rod) {
    final int _weeklyCompletionGoal =
        widget.habit!.completionGoal! * widget.habit!.scheduledWeekDays.length;
    final double _weeklyCompletionPercentage =
        (rod.y / _weeklyCompletionGoal) * 100;
    return BarTooltipItem(
        '${'Week'.tr}$weekNumber\n${_weeklyCompletionPercentage.toInt()}%',
        Theme.of(context).textTheme.caption!.copyWith(color: kDeepOrange));
  }

  BarTooltipItem _createTooltipItemForDay(String? weekDay, BarChartRodData rod) {
    final double _dailyCompletionPercentage =
        (rod.y / widget.habit!.completionGoal!) * 100;
    final String _test = "${rod.y.toInt()}/${widget.habit!.completionGoal}";
    return BarTooltipItem(
        '$weekDay\n$_test\n${_dailyCompletionPercentage.toInt()}%',
        Theme.of(context).textTheme.caption!.copyWith(color: kDeepOrange));
  }
}
