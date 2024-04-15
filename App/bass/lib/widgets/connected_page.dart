import 'dart:async';

import 'package:bass/widgets/raw_data_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'assistant_page.dart';

class ConnectedPage extends StatefulWidget {
  final BluetoothService mtuService;

  final TabController tabController;
  const ConnectedPage(
      {super.key, required this.mtuService, required this.tabController});

  @override
  State<ConnectedPage> createState() => _ConnectedPageState();
}

class _ConnectedPageState extends State<ConnectedPage> {
  late StreamSubscription<List<int>> _lastValueSubscription;
  bool subscribed = false;

  List<int> _value = [];

  @override
  void initState() {
    super.initState();
    subscribe().then((value) {
      subscribed = true;
      if (mounted) {
        setState(() {});
      }
    });
    _lastValueSubscription = c.lastValueStream.listen((value) {
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

  BluetoothCharacteristic get c => widget.mtuService.characteristics.first;

  Future<void> subscribe() async {
    try {
      await c.setNotifyValue(c.isNotifying == false);
      await c.read();
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return subscribed
        ? SizedBox(
            width: mediaQuery.size.width,
            height: mediaQuery.size.height * 0.75,
            child: TabBarView(
              controller: widget.tabController,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      AssistantPage(
                        data: _value,
                      )
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      RawPage(
                        data: _value,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        : const CircularProgressIndicator();
  }
}
