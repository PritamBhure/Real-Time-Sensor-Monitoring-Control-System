import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SensorChart extends StatelessWidget {
  final List<FlSpot> dataPoints;
  final Color color;

  const SensorChart({
    super.key,
    required this.dataPoints,
    this.color = Colors.blue
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false), // Clean look
        titlesData: const FlTitlesData(show: false), // No axis labels
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: dataPoints,
            isCurved: true,
            color: color,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
                show: true,
                color: color.withOpacity(0.2)
            ),
          ),
        ],
        // Keep the chart within fixed bounds so it doesn't jump around
        minY: 0,
        maxY: 120,
      ),
    );
  }
}