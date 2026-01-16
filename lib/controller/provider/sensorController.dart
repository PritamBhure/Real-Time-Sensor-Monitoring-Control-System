// file: lib/controller/provider/sensorController.dart
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:digital_control_room/core/contants/appApiConts.dart';
import '../../model/sensorModel/sensorModel.dart';

class SensorController extends ChangeNotifier {
  Map<String, SensorModel> _sensors = {};
  Map<String, List<FlSpot>> _history = {};
  Map<String, DateTime> _lastUpdateTimes = {};
  late WebSocketChannel channel;
  Timer? _healthCheckTimer;

  Map<String, SensorModel> get sensors => _sensors;
  Map<String, List<FlSpot>> get history => _history;


  // Helper function (same as in UI)
  bool _isCritical(SensorModel s) {
  if (s.id.contains("TEMP")) return s.value > 80.0;
  if (s.id.contains("PRES")) return s.value > 7.5;
  if (s.id.contains("VOLT")) return s.value > 238.0 || s.value < 222.0;
  if (s.id.contains("VIBE")) return s.value > 4.0;
  if (s.id.contains("FLOW")) return s.value < 42.0;
  if (s.id.contains("HUMI")) return s.value > 65.0;
  return s.value > 90.0;

  }

  // --- NEW: Analytics Getters for the Header ---
  int get totalSensors => _sensors.length;
  int get offlineCount => _sensors.values.where((s) => !s.isOnline).length;
  int get alertCount => _sensors.values.where((s) => _isCritical(s) && s.isOnline).length;
  // ---------------------------------------------

  SensorController() {
    _initStreaming();
    _startHealthCheck();
  }

  void _initStreaming() {
    // ... (Keep your existing connection logic exactly the same) ...
    // COPY PASTE YOUR EXISTING _initStreaming CODE HERE
    channel = WebSocketChannel.connect(Uri.parse(AppApiConst.webSocketUrl));
    channel.stream.listen((data) {
      final decoded = jsonDecode(data);
      final newReading = SensorModel.fromJson(decoded);

      _sensors[newReading.id] = newReading;

      if (!_history.containsKey(newReading.id)) {
        _history[newReading.id] = [];
      }

      // Using a simplified counter for smoother X-axis scrolling
      double xValue = DateTime.now().millisecondsSinceEpoch.toDouble();
      _history[newReading.id]!.add(FlSpot(xValue, newReading.value));

      if (_history[newReading.id]!.length > 30) { // Increased history slightly
        _history[newReading.id]!.removeAt(0);
      }

      _lastUpdateTimes[newReading.id] = DateTime.now();
      notifyListeners();
    }, onError: (err) => log("Error: $err"));
  }

  void _startHealthCheck() {
    _healthCheckTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      final now = DateTime.now();
      bool statusChanged = false;
      _sensors.forEach((id, sensor) {
        final lastSeen = _lastUpdateTimes[id];
        if (lastSeen != null) {
          final isOffline = now.difference(lastSeen).inSeconds > 5;
          if (sensor.isOnline == isOffline) {
            _sensors[id] = SensorModel(
              id: sensor.id,
              value: sensor.value,
              unit: sensor.unit,
              timestamp: sensor.timestamp,
              isOnline: !isOffline,
            );
            statusChanged = true;
          }
        }
      });
      if (statusChanged) notifyListeners();
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    _healthCheckTimer?.cancel();
    super.dispose();
  }
}