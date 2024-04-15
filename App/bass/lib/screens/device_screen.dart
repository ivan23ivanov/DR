import 'dart:async';

import 'package:bass/widgets/connected_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../utils/extra.dart';

class DeviceScreen extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen>
    with TickerProviderStateMixin {
  int? _rssi;
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;
  late Future<BluetoothService> _service;
  bool _isConnecting = false;
  bool _isDisconnecting = false;

  late final TabController _tabController;
  late StreamSubscription<BluetoothConnectionState>
      _connectionStateSubscription;
  late StreamSubscription<bool> _isConnectingSubscription;
  late StreamSubscription<bool> _isDisconnectingSubscription;

  final StreamController<List<int>> _dataStreamController =
      StreamController<List<int>>();
  Stream<List<int>> get dataStream => _dataStreamController.stream;

  static const String BASSServiceUUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _connectionStateSubscription =
        widget.device.connectionState.listen((state) async {
      _connectionState = state;
      if (state == BluetoothConnectionState.connected) {
        _service = discoverServices(); // must rediscover services
      }
      if (state == BluetoothConnectionState.connected && _rssi == null) {
        _rssi = await widget.device.readRssi();
      }
      if (mounted) {
        setState(() {});
      }
    });

    _isConnectingSubscription = widget.device.isConnecting.listen((value) {
      _isConnecting = value;
      if (mounted) {
        setState(() {});
      }
    });

    _isDisconnectingSubscription =
        widget.device.isDisconnecting.listen((value) {
      _isDisconnecting = value;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    _isConnectingSubscription.cancel();
    _isDisconnectingSubscription.cancel();
    super.dispose();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  Future onConnectPressed() async {
    try {
      await widget.device.connectAndUpdateStream();
    } catch (e) {
      if (e is FlutterBluePlusException &&
          e.code == FbpErrorCode.connectionCanceled.index) {
        // ignore connections canceled by the user
      } else {}
    }
  }

  Future onCancelPressed() async {
    try {
      await widget.device.disconnectAndUpdateStream(queue: false);
    } catch (e) {}
  }

  Future onDisconnectPressed() async {
    try {
      await widget.device.disconnectAndUpdateStream();
    } catch (e) {}
  }

  Future<BluetoothService> discoverServices() async {
    try {
      List<BluetoothService> services = await widget.device.discoverServices();
      return services
          .firstWhere((BluetoothService e) => e.uuid.str == BASSServiceUUID);
    } catch (e) {
      return Future.error(e);
    }
  }

  Widget buildSpinner(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(14.0),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: CircularProgressIndicator(
          backgroundColor: Colors.black12,
          color: Colors.black26,
        ),
      ),
    );
  }

  Widget buildConnectButton(BuildContext context) {
    return Row(children: [
      if (_isConnecting || _isDisconnecting) buildSpinner(context),
      TextButton(
          onPressed: _isConnecting
              ? onCancelPressed
              : (isConnected ? onDisconnectPressed : onConnectPressed),
          child: Text(
            _isConnecting ? "CANCEL" : (isConnected ? "DISCONNECT" : "CONNECT"),
            style: Theme.of(context)
                .primaryTextTheme
                .labelLarge
                ?.copyWith(color: Colors.white),
          ))
    ]);
  }

  Widget buildRssiTile(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isConnected
            ? const Icon(Icons.bluetooth_connected)
            : const Icon(Icons.bluetooth_disabled),
        Text(((isConnected && _rssi != null) ? '${_rssi!} dBm' : ''),
            style: Theme.of(context).textTheme.bodySmall)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.device.platformName),
          actions: [buildConnectButton(context)],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                icon: Icon(Icons.how_to_reg_rounded),
              ),
              Tab(
                icon: Icon(Icons.data_exploration_outlined),
              ),
            ],
          )),
      body: Column(
        children: [
          ListTile(
            leading: buildRssiTile(context),
            title:
                Text('BASS is ${_connectionState.toString().split('.')[1]}.'),
          ),
          FutureBuilder<BluetoothService>(
            future: _service,
            builder: (BuildContext context,
                AsyncSnapshot<BluetoothService> snapshot) {
              if (snapshot.hasData) {
                final BluetoothService mtuService = snapshot.data!;
                return ConnectedPage(
                  mtuService: mtuService,
                  tabController: _tabController,
                );
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text("TODO HANDLE APP REFRESH BUTTON")); //TODO
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
