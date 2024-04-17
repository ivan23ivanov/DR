import 'package:bass/utils/assistant.dart';
import 'package:flutter/material.dart';

class AssistantPage extends StatefulWidget {
  List<int> data;

  AssistantPage({Key? key, required this.data}) : super(key: key);

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  String waterTemp = "";
  String waterTempMessage = "";
  String airTemp = "";
  String airTempMessage = "";
  String pressure = "";
  String pressureMessage = "";
  String depth = "";
  String depthMessage = "";

  static const String depthString = "Depth:";
  static const String airTString = "Air T:";
  static const String waterTString = "Water T:";
  static const String pressureString = "Press.:";

  void buildValue(BuildContext context) {
    String data = String.fromCharCodes(widget.data);
    if (data.contains(depthString)) {
      depth = data;
      depthMessage =
          Assistant.waterDepthMessage(Assistant.getVal(depth, depthString));
      setState(() {});
    }
    if (data.contains(airTString)) {
      airTemp = data;
      airTempMessage =
          Assistant.airTempMessage(Assistant.getVal(airTemp, airTString));
      setState(() {});
    }
    if (data.contains(waterTString)) {
      waterTemp = data;
      waterTempMessage =
          Assistant.waterTempMessage(Assistant.getVal(waterTemp, waterTString));
      setState(() {});
    }
    if (data.contains(pressureString)) {
      pressure = data;
      pressureMessage =
          Assistant.pressureMessage(Assistant.getVal(pressure, pressureString));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    buildValue(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Асистентът препоръчва:'),
          Text(depthMessage),
          Text(airTempMessage),
          Text(waterTempMessage),
          Text(pressureMessage),
        ],
      ),
    );
  }
}
