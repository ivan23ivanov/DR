import 'package:flutter/material.dart';

class RawPage extends StatefulWidget {
  List<int> data;

  RawPage({Key? key, required this.data}) : super(key: key);

  @override
  State<RawPage> createState() => _RawPageState();
}

class _RawPageState extends State<RawPage> {
  String waterTemp = "";
  String airTemp = "";
  String pressure = "";
  String depth = "";

  static const String depthString = "Depth:";
  static const String airTString = "Air T:";
  static const String waterTString = "Water T:";
  static const String pressureString = "Press.:";

  @override
  void dispose() {
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    buildValue(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Environmental Parameters:'),
        Text(depth),
        Text(airTemp),
        Text(waterTemp),
        Text(pressure),
      ],
    );
  }
}
