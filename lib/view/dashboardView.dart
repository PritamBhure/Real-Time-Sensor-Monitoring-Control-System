import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/provider/sensorController.dart';
import '../core/utils/summaryCard.dart';
import 'IndustrialSensorCard.dart'; // Import the new card

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C), // Deep Blue-Grey Background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomScrollView(
            slivers: [
              // 1. APP BAR SECTION
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CONTROL ROOM",
                            style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                                letterSpacing: 2
                            ),
                          ),
                          Text(
                            "SYSTEM MONITOR",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      // CircleAvatar(
                      //   backgroundColor: Color(0xFF2D2D44),
                      //   child: Icon(Icons.settings, color: Colors.white),
                      // )
                    ],
                  ),
                ),
              ),

              // 2. STATUS SUMMARY CARDS (Top Row)
              SliverToBoxAdapter(
                child: Consumer<SensorController>(
                  builder: (context, controller, child) {
                    return Row(
                      children: [
                        buildSummaryCard("TOTAL SENSORS", "${controller.totalSensors}", Colors.blue),
                        const SizedBox(width: 10),
                        buildSummaryCard("ACTIVE ALERTS", "${controller.alertCount}", Colors.redAccent),
                        const SizedBox(width: 10),
                        buildSummaryCard("OFFLINE", "${controller.offlineCount}", Colors.orange),
                      ],
                    );
                  },
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // 3. SENSOR GRID
              Consumer<SensorController>(
                builder: (context, controller, child) {
                  final sensorList = controller.sensors.values.toList();

                  return SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85, // Taller cards for better chart fit
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final sensor = sensorList[index];
                        final history = controller.history[sensor.id] ?? [];

                        return IndustrialSensorCard(
                          sensor: sensor,
                          history: history,
                        );
                      },
                      childCount: sensorList.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


}