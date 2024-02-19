import 'dart:async';

import 'package:bass/utils/assistant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class AssistantPage extends StatefulWidget {
  final BluetoothCharacteristic characteristic;

  const AssistantPage({Key? key, required this.characteristic})
      : super(key: key);

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  List<int> _value = [];

  String waterTemp = "";
  String waterTempMessage = "";
  String airTemp = "";
  String airTempMessage = "";
  String pressure = "";
  String pressureMessage = "";
  String depth = "";
  String depthMessage = "";

  late StreamSubscription<List<int>> _lastValueSubscription;
  bool subscribed = false;

  static const String depthString = "Depth:";
  static const String airTString = "Air T:";
  static const String waterTString = "Water T:";
  static const String pressureString = "Press.:";

  @override
  void initState() {
    super.initState();
    subscribe().then((value) {
      subscribed = true;
      if (mounted) {
        setState(() {});
      }
    });
    _lastValueSubscription =
        widget.characteristic.lastValueStream.listen((value) {
      _value = value;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _lastValueSubscription.cancel();
    super.dispose();
  }

  BluetoothCharacteristic get c => widget.characteristic;

  Future<void> subscribe() async {
    try {
      await c.setNotifyValue(c.isNotifying == false);
      await c.read();
    } catch (e) {
      return Future.error(e);
    }
  }

  void buildValue(BuildContext context) {
    String data = String.fromCharCodes(_value);
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
    return subscribed
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Асистентът препоръчва:'),
              Text(depthMessage),
              Text(airTempMessage),
              Text(waterTempMessage),
              Text(pressureMessage),
            ],
          )
        : const CircularProgressIndicator();
  }
}
