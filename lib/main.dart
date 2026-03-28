import 'package:flutter/material.dart';
import 'screen/home_screen.dart';

void main() {
  runApp(const PocketFlowApp());
}

class PocketFlowApp extends StatelessWidget {
  const PocketFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PocketFlow',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
