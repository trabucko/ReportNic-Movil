import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReportNic',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Montserrat' // Configura la fuente globalmente
          ),
      home: const SplashScreen(),
    );
  }
}
