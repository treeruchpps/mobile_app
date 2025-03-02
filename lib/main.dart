import 'package:flutter/material.dart';
// import 'package:mobile_app/product/product_list.dart';
import 'package:mobile_app/trafficlight/traffic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TrafficLightScreen(),
    );
  }
}
