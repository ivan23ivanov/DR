import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class RawPage extends StatefulWidget {
  final BluetoothCharacteristic characteristic;

  const RawPage({Key? key, required this.characteristic}) : super(key: key);

  @override
  State<RawPage> createState() => _RawPageState();
}

class _RawPageState extends State<RawPage> {
  List<int> _value = [];

  String waterTemp = "";
  String airTemp = "";
  String pressure = "";
  String depth = "";

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
    return subscribed
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Environmental Parameters:'),
              Text(depth),
              Text(airTemp),
              Text(waterTemp),
              Text(pressure),
            ],
          )
        : const CircularProgressIndicator();
  }
}
