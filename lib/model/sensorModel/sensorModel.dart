class SensorModel {
  final String id;
  final double value;
  final String unit; // °C, PSI, Volts
  final DateTime timestamp;
  final bool isOnline;

  SensorModel({
    required this.id,
    required this.value,
    required this.unit,
    required this.timestamp,
    this.isOnline = true,
  });

  // Convert JSON from MQTT/WebSocket to our Model
  factory SensorModel.fromJson(Map<String, dynamic> json) {
    return SensorModel(
      id: json['id'],
      value: json['value'].toDouble(),
      unit: json['unit'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}