import 'package:Marbit/models/models.dart';
import 'package:Marbit/screens/createItemScreen.dart';
import 'package:Marbit/util/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum TimeSpan { WEEK, MONTH, YEAR }

class HabitCompletionChart extends StatefulWidget {
  final Habit habit;

  const HabitCompletionChart({Key key, this.habit}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HabitCompletionChartState();
}

class HabitCompletionChartState extends State<HabitCompletionChart> {
  final Color barBackgroundColor = kLightOrange;
  final Color barColor = kDeepOrange;
  final Color elementColor = kBackGroundWhite;
  final Duration animDuration = const Duration(milliseconds: 250);

  int _touchedIndex;
  bool _isPlaying = false;
  double _maxBarValue = 0;
  TimeSpan _timeSpan = TimeSpan.WEEK;
  List _data = [];

  List<TrackedDay> _weekData;
  List<CalendarWeek> _monthData;
  List<CalendarWeek> _yearData;

  void _updateData() {
    _data = widget.habit.getCompletionDataForTimeSpan(_timeSpan);
  }

  Row _buildTimespanButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MaterialButton(
            onPressed: () {
              setState(() {
                _maxBarValue = 0;
                _timeSpan = TimeSpan.WEEK;
                _updateData();
              });
            },
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: _timeSpan == TimeSpan.WEEK ? kDeepOrange : kBackGroundWhite,
            child: Text(
              "This Week",
              style: Theme.of(context).textTheme.button.copyWith(
                  fontSize: 12,
                  color: _timeSpan == TimeSpan.WEEK
                      ? kBackGroundWhite
                      : kDeepOrange),
            )),
        MaterialButton(
            onPressed: () {
              setState(() {
                _maxBarValue = 0;
                _timeSpan = TimeSpan.MONTH;
                _updateData();
              });
            },
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: _timeSpan == TimeSpan.MONTH ? kDeepOrange : kBackGroundWhite,
            child: Text("Last 4 Weeks",
                style: Theme.of(context).textTheme.button.copyWith(
                    fontSize: 12,
                    color: _timeSpan == TimeSpan.MONTH
                        ? kBackGroundWhite
                        : kDeepOrange))),
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
    return Container(
      width: double.infinity,
      // aspectRatio: 1.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(flex: 1, child: _buildTimespanButtonRow()),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 3,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: elementColor,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        const SizedBox(
                          height: 12,
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                ],
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
          borderRadius: BorderRadius.circular(5),
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
    List<BarChartGroupData> _dataList = [];

    switch (_timeSpan) {
      case TimeSpan.WEEK:
        if (_weekData == null) _weekData = _data as List<TrackedDay>;

        assert(
            _weekData.length == 7, "WeekData length was ${_weekData.length}");

        for (var i = 0; i < _weekData.length; i++) {
          TrackedDay day = _weekData[i];
          if (_maxBarValue != widget.habit.completionGoal)
            _maxBarValue = widget.habit.completionGoal.toDouble();

          _dataList.add(makeGroupData(i, day.doneAmount.toDouble(),
              isTouched: i == _touchedIndex));
        }

        return _dataList;
        break;
      case TimeSpan.MONTH:
        if (_monthData == null) _monthData = _data as List<CalendarWeek>;

        assert(_monthData.length == 4,
            "Monthdata length was ${_monthData.length}");

        for (var i = 0; i < _monthData.length; i++) {
          List<TrackedDay> _daylist = _monthData[i].trackedDays;
          double _completions = 0;

          for (TrackedDay _day in _daylist) {
            _completions += _day.doneAmount;
          }

          _maxBarValue = (widget.habit.completionGoal *
                  widget.habit.scheduledWeekDays.length)
              .toDouble();

          _dataList.add(
              makeGroupData(i, _completions, isTouched: i == _touchedIndex));
        }

        return _dataList;
        break;
      case TimeSpan.YEAR:
        return _dataList;
        break;
    }
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: kBackGroundWhite,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              switch (_timeSpan) {
                case TimeSpan.WEEK:
                  String weekDay;
                  switch (group.x.toInt()) {
                    case 0:
                      weekDay = 'Monday';
                      break;
                    case 1:
                      weekDay = 'Tuesday';
                      break;
                    case 2:
                      weekDay = 'Wednesday';
                      break;
                    case 3:
                      weekDay = 'Thursday';
                      break;
                    case 4:
                      weekDay = 'Friday';
                      break;
                    case 5:
                      weekDay = 'Saturday';
                      break;
                    case 6:
                      weekDay = 'Sunday';
                      break;
                  }
                  return _createTooltipItemForDay(weekDay, rod);
                  break;
                case TimeSpan.MONTH:
                  String weekNumber;
                  for (var i = 0; i < _monthData.length; i++) {
                    weekNumber = '${_monthData[i].weekNumber}';
                    _createTooltipItemForWeek(weekNumber, rod);
                  }
                  break;
                case TimeSpan.YEAR:
                  break;
              }
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! PointerUpEvent &&
                barTouchResponse.touchInput is! PointerExitEvent) {
              _touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
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
          getTextStyles: (value) => const TextStyle(
              color: kLightOrange, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            int _value = value.toInt();
            switch (_timeSpan) {
              case TimeSpan.WEEK:
                return dayNames[_value];
                break;
              case TimeSpan.MONTH:
                String test = _monthData[_value].weekNumber.toString();
                return "test"; //_monthData[_value].weekNumber.toString();
                break;
              case TimeSpan.YEAR:
                break;
            }
          },
        ),
        leftTitles: SideTitles(
          margin: 20,
          showTitles: true,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: getGroupData(),
    );
  }

  BarTooltipItem _createTooltipItemForWeek(
      String weekNumber, BarChartRodData rod) {
    int _weeklyCompletionGoal =
        widget.habit.completionGoal * widget.habit.scheduledWeekDays.length;
    double _weeklyCompletionPercentage = (rod.y / _weeklyCompletionGoal) * 100;
    return BarTooltipItem(
        'Week ' +
            weekNumber +
            '\n' +
            _weeklyCompletionPercentage.toInt().toString() +
            '%',
        Theme.of(context).textTheme.button);
  }

  BarTooltipItem _createTooltipItemForDay(String weekDay, BarChartRodData rod) {
    double _dailyCompletionPercentage =
        (rod.y / widget.habit.completionGoal) * 100;
    return BarTooltipItem(
        weekDay + '\n' + _dailyCompletionPercentage.toInt().toString() + '%',
        Theme.of(context).textTheme.button);
  }
}
