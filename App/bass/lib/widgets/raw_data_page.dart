import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RawPage extends StatefulWidget {
  List<int> data;

  RawPage({Key? key, required this.data}) : super(key: key);

  @override
  State<RawPage> createState() => _RawPageState();
}

class _RawPageState extends State<RawPage> {
  static const String depthString = "Depth:";
  static const String airTString = "Air T:";
  static const String waterTString = "Water T:";
  static const String pressureString = "Press.:";

  String waterTemp = "";
  String airTemp = "";
  String pressure = "";
  String depth = "";

  final airTPoints = <FlSpot>[];
  final waterTPoints = <FlSpot>[];
  final depthPoints = <FlSpot>[];
  final pressurePoints = <FlSpot>[];

  late Timer timer;

  static const double pointCount = 30;

  double time = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      while (airTPoints.length > pointCount) {
        airTPoints.removeAt(0);
      }
      while (depthPoints.length > pointCount) {
        depthPoints.removeAt(0);
      }
      while (pressurePoints.length > pointCount) {
        pressurePoints.removeAt(0);
      }
      while (waterTPoints.length > pointCount) {
        waterTPoints.removeAt(0);
      }
      setState(() {
        airTPoints.add(FlSpot(time, getDataVal(airTemp)));
        depthPoints.add(FlSpot(time, getDataVal(depth)));
        pressurePoints.add(FlSpot(time, getDataVal(pressure)));
        waterTPoints.add(FlSpot(time, getDataVal(waterTemp)));
      });
      time += 2;
    });
  }

  double getDataVal(String val) {
    if (val.isEmpty) {
      return 0;
    }
    val = val.substring(val.indexOf(':'));
    return double.parse(val.split(' ')[1]);
  }

  void buildValue(BuildContext context) {
    String data = String.fromCharCodes(widget.data);
    if (data.contains(depthString)) {
      depth = data;
      setState(() {});
    }
    if (data.contains(airTString)) {
      airTemp = data;
      setState(() {});
    }
    if (data.contains(waterTString)) {
      waterTemp = data;
      setState(() {});
    }
    if (data.contains(pressureString)) {
      pressure = data;
      setState(() {});
    }
  }

  Widget textGraph(String text, double minY, double maxY, List<FlSpot> points) {
    return Column(
      children: [
        Text(text),
        const SizedBox(
          height: 10,
        ),
        buildGraph(minY, maxY, points)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    buildValue(context);
    final md = MediaQuery.of(context);
    return SizedBox(
      width: md.size.width,
      height: md.size.height * 0.8,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Environmental Parameters:'),
              textGraph(depth, 650, 30, depthPoints),
              Divider(height: 10),
              textGraph(airTemp, -10, 50, airTPoints),
              Divider(height: 10),
              textGraph(waterTemp, -10, 50, waterTPoints),
              Divider(height: 10),
              textGraph(pressure, 800, 1000, pressurePoints),
              Divider(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGraph(double minY, double maxY, List<FlSpot> points) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: LineChart(
          LineChartData(
            minY: minY,
            maxY: maxY,
            minX: points.first.x,
            maxX: time > pointCount ? time : pointCount,
            lineTouchData: const LineTouchData(enabled: false),
            clipData: const FlClipData.all(),
            gridData: const FlGridData(
              show: true,
              drawVerticalLine: false,
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: points,
                dotData: const FlDotData(
                  show: false,
                ),
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.green],
                  stops: [0.1, 1.0],
                ),
                barWidth: 4,
                isCurved: true,
              )
            ],
            titlesData: const FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                ),
              ),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  reservedSize: 100,
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
          ),
        ),
      ),
    );
  }
}
