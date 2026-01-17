import 'package:digital_control_room/view/dashboardView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/provider/sensorController.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SensorController()),
        ],
        child: const MyApp(),
      ),

  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home:DashboardView()
    );
  }
}



