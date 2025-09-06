import 'dart:async';

import 'package:flutter/foundation.dart' show DiagnosticableTreeMixin;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ObdReader())],
      child: MyApp(),
    ),
  );
}

Widget buildCard(String title, String obdData) {
  return Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(15, 15, 0, 0),
          alignment: Alignment.topLeft,
          height: 30.0,
          child: Text(title),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 15),
            height: 100.0,
            child: Center(child: Text(obdData)),
          ),
        ),
      ],
    ),
  );
}

class BluetoothObd {
  static const MethodChannel _channel = MethodChannel('bluetooth_obd');

  // 获得 OBD 数据
  static Future<String> get getAirIntakeTemperature async {
    final String data = await _channel.invokeMethod('getAirIntakeTemperature');
    return data;
  }

  // 获得 OBD 数据
  static Future<String> get getDistanceMILOn async {
    final String data = await _channel.invokeMethod('getDistanceMILOn');
    return data;
  }

  // 获得 OBD-车速 数据
  static Future<String> get getEngineLoad async {
    final String data = await _channel.invokeMethod('getEngineLoad');
    return data;
  }

  // 获得 OBD RPM 数据
  static Future<String> get getModuleVoltage async {
    final String data = await _channel.invokeMethod('getModuleVoltage');
    return data;
  }

  // 获得 OBD RPM 数据
  static Future<String> get getRPM async {
    final String data = await _channel.invokeMethod('getRPM');
    return data;
  }

  // 获得 OBD-车速 数据
  static Future<String> get getSpeed async {
    final String tripRecords = await _channel.invokeMethod('getSpeed');
    return tripRecords;
  }

  // 启动 OBD 连接
  static Future<String> get startOBD async {
    final String startOBDMesg = await _channel.invokeMethod('startOBD');
    return startOBDMesg;
  }

  // 获得 OBD 数据
  static Future<String> get tripRecord async {
    final String tripRecords = await _channel.invokeMethod('getTripRecord');
    return tripRecords;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class ObdReader with ChangeNotifier, DiagnosticableTreeMixin {
  final String _tripRecords = '';
  String _obdSpeed = '';
  String _obdEngineCoolantTemp = '';
  String _obdEngineLoad = '';
  String _obdEngineRpm = '';
  String _obdModuleVoltage = '';
  String _obdDistanceMILOn = '';
  final Map _obdData = {
    '0': ['Speed', '0'],
    '1': ['CoolantTemperature', '0'],
    '2': ['RPM', '0'],
    '3': ['EngineLoad', '0'],
    '4': ['ModuleVoltage', '0'],
    '5': ['DistanceMILOn', '0'],
  };

  Map get obdData => _obdData;
  String get obdDistanceMILOn => _obdDistanceMILOn;
  String get obdEngineCoolantTemp => _obdEngineCoolantTemp;
  String get obdEngineLoad => _obdEngineLoad;
  String get obdEngineRpm => _obdEngineRpm;
  String get obdModuleVoltage => _obdModuleVoltage;
  String get obdSpeed => _obdSpeed;
  String get tripRecords => _tripRecords;

  Future<void> increment() async {
    // try {
    //   _tripRecords = await BluetoothObd.getSpeed;
    //   _obdData['0'][1] = _tripRecords;
    // } on PlatformException {
    //   _tripRecords = 'Failed to get tripRecords.';
    //   _obdData['0'][1] = 'Failed to get airIntakeTemperature.';
    // }

    // obd speed
    try {
      _obdSpeed = await BluetoothObd.getSpeed;
      _obdData['0'][1] = _obdSpeed;
    } on PlatformException {
      _obdSpeed = 'Failed to get speed.';
      _obdData['0'][1] = 'Failed to get speed.';
    }
    // obd EngineCoolantTemp
    try {
      _obdEngineCoolantTemp = await BluetoothObd.getAirIntakeTemperature;
      _obdData['1'][1] = _obdEngineCoolantTemp;
    } on PlatformException {
      _obdSpeed = 'Failed to get Engine Coolant Temp.';
      _obdData['1'][1] = 'Failed to get Engine Coolant Temp.';
    }
    // 获得 OBD RPM 数据
    try {
      _obdEngineRpm = await BluetoothObd.getRPM;
      _obdData['2'][1] = _obdEngineRpm;
    } on PlatformException {
      _obdEngineRpm = 'Failed to get Engine Rpm.';
      _obdData['2'][1] = 'Failed to get Engine Rpm.';
    }
    // obd getEngineLoad
    try {
      _obdEngineLoad = await BluetoothObd.getEngineLoad;
      _obdData['3'][1] = _obdEngineLoad;
    } on PlatformException {
      _obdEngineLoad = 'Failed to get Engine Load.';
      _obdData['3'][1] = 'Failed to get Engine Load.';
    }
    // obd getModuleVoltage
    try {
      _obdModuleVoltage = await BluetoothObd.getModuleVoltage;
      _obdData['4'][1] = _obdModuleVoltage;
    } on PlatformException {
      _obdModuleVoltage = 'Failed to get Module Voltage.';
      _obdData['4'][1] = 'Failed to get Module Voltage.';
    }
    // obd getDistanceMILOn
    try {
      _obdDistanceMILOn = await BluetoothObd.getDistanceMILOn;
      _obdData['5'][1] = _obdDistanceMILOn;
    } on PlatformException {
      _obdDistanceMILOn = 'Failed to get Distance MILOn.';
      _obdData['5'][1] = 'Failed to get Distance MILOn.';
    }
    notifyListeners();
  }

  Future<void> startOBD() async {
    String obdMesg;
    try {
      obdMesg = await BluetoothObd.startOBD;
    } on PlatformException {
      obdMesg = 'Failed to start obdMesg.';
    }

    print(obdMesg);

    notifyListeners();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('OBD READER'),
          actions: [
            IconButton(
              tooltip: 'connect OBD',
              icon: const Icon(Icons.bluetooth),
              onPressed: () => context.read<ObdReader>().startOBD(),
            ),
            IconButton(
              tooltip: 'Refresh OBD Data',
              icon: const Icon(Icons.refresh),
              onPressed: () => context.read<ObdReader>().increment(),
            ),
            IconButton(
              tooltip: 'starterAppTooltipSearch',
              icon: const Icon(Icons.bluetooth_disabled),
              onPressed: () {},
            ),
          ],
        ),
        body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          children: List.generate(6, (index) {
            return buildCard(
              context.watch<ObdReader>().obdData['$index'][0],
              context.watch<ObdReader>().obdData['$index'][1],
            );
          }),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // initPlatformState();
  }
}
