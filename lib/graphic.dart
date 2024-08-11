import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math' as math;

class chart extends StatefulWidget {
  const chart({super.key});

  @override
  State<chart> createState() => _chartState();
}

class _chartState extends State<chart> {
  int minDate = double.maxFinite.toInt();
  int maxDate = 0;

  int minReps = double.maxFinite.toInt();
  int maxReps = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getLineData(),
      builder: (context, snapshot) {
        return Scaffold(
          body: Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(0, 40, 20, 35),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 25,
                      //interval: snapshot.hasData ? (maxDate - minDate + 10).toDouble() : 1,
                      getTitlesWidget: bottomTitleWidgets,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      getTitlesWidget: leftTitleWidgets,
                      showTitles: true,
                      interval: snapshot.hasData && (maxReps / 3) != 0 ? (maxReps / 3).toDouble() : 1,
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom:
                        BorderSide(color: Colors.purpleAccent.withOpacity(0.2), width: 4),
                    left: const BorderSide(color: Colors.transparent),
                    right: const BorderSide(color: Colors.transparent),
                    top: const BorderSide(color: Colors.transparent),
                  ),
                ),
                lineBarsData: [
                  snapshot.hasData
                  ? snapshot.data! 
                  : LineChartBarData(spots: [])
                ],
                minX: snapshot.hasData 
                  ? minDate.toDouble() 
                  : 10,
                maxX: snapshot.hasData 
                ? minDate == maxDate  
                  ? maxDate.toDouble()
                  : maxDate.toDouble() + 10
                : 10,
                maxY: snapshot.hasData && maxReps != 0 ? maxReps.toDouble() : 1,
                minY: 0,
              )
            ),
          ),
        );
      }
    );
  }

  Future<LineChartBarData> getLineData() async {
    List<FlSpot> chartSpots = [];
    int localmaxint;
    final database = await openDatabase(  
      version: 1,
      join(await getDatabasesPath(), 'shiko_database.db'),
    );

    final dbRes = await database.query(
      'shiko_records',
      orderBy: 'id DESC',
      limit: 5,
    );

    var reversedDB = dbRes.reversed;

    for (var element in reversedDB) {
      if ((element['time'] as int) < minDate) {
        minDate = (element['time'] as int);
      } else if ((element['time'] as int) > maxDate) {
        maxDate = (element['time'] as int);
      }

      if ((element['reps'] as int) < minReps) {
        minReps = (element['reps'] as int);
      } else if ((element['reps'] as int) > maxReps) {
        maxReps = (element['reps'] as int);
      }

      chartSpots.add(
        FlSpot(
          (element['time'] as int).toDouble(), 
          (element['reps'] as int).toDouble()
        )
      );
    }

    return LineChartBarData(
      show: true,
      color: Colors.purpleAccent,
      spots: chartSpots
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 6,
    );
    Widget text;
    String date = 
      DateFormat('MMM-dd').format(DateTime.fromMillisecondsSinceEpoch(value.toInt())) + "\n" +
      DateFormat('hh:mm').format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
    text = Text(date, style: style, textAlign: TextAlign.center,);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 6,
      child: Transform.rotate(
        angle: -math.pi / 4,
        child: text),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 6,
    );
    String text;

    text = value.toInt().toString();

    return Text(text, style: style, textAlign: TextAlign.center);
  }

}