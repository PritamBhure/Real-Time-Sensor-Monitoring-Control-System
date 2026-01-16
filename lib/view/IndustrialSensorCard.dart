import 'package:digital_control_room/model/sensorModel/sensorModel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../core/utils/checkCriticalStatus.dart';
import 'sensorChart.dart';

class IndustrialSensorCard extends StatelessWidget {
  final SensorModel sensor;
  final List<FlSpot> history;

  const IndustrialSensorCard({super.key, required this.sensor, required this.history});



  @override
  Widget build(BuildContext context) {
    // 1. Determine State using the new logic
    bool isCritical = checkCriticalStatus(sensor.id, sensor.value);
    bool isOffline = !sensor.isOnline;

    // 2. Define Colors based on State
    Color statusColor = isOffline
        ? Colors.grey
        : (isCritical ? Colors.redAccent : const Color(0xFF00F2FF)); // Neon Blue or Red

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D44),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          // Show Red Border ONLY if Critical and Online
          color: isCritical && !isOffline ? Colors.red.withOpacity(0.8) : Colors.transparent,
          width: 2,
        ),
        boxShadow: isCritical && !isOffline
            ? [BoxShadow(color: Colors.red.withOpacity(0.4), blurRadius: 12, spreadRadius: 2)]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // CONTENT
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        sensor.id,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isOffline ? "OFFLINE" : (isCritical ? "ALERT" : "NORMAL"),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),

                  const Spacer(),

                  // MAIN VALUE
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        sensor.value.toStringAsFixed(1),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6, left: 4),
                        child: Text(
                          sensor.unit,
                          style: const TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // CHART
                  SizedBox(
                    height: 50,
                    child: SensorChart(
                      dataPoints: history,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),

            // OFFLINE OVERLAY
            if (isOffline)
              Container(
                color: Colors.black.withOpacity(0.6),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.wifi_off, color: Colors.white54, size: 30),
                    SizedBox(height: 4),
                    Text(
                      "SIGNAL LOST",
                      style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}