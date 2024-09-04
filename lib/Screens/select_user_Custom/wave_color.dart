// wave_colors.dart
import 'package:flutter/material.dart';

class WaveColors {
  static List<Color> defaultWaveColors = [
    const Color.fromARGB(255, 99, 93, 93).withOpacity(0.9),
    const Color.fromARGB(255, 99, 93, 93).withOpacity(0.8),
    const Color.fromARGB(255, 99, 93, 93).withOpacity(0.7),
    const Color.fromARGB(255, 163, 162, 162),
  ];

  static List<Color> blueWaveColors = [
    Colors.blue.withOpacity(0.7),
    Colors.blue.withOpacity(0.6),
    Colors.blue.withOpacity(0.5),
    Colors.blue,
  ];

  static List<Color> redWaveColors = [
    Colors.red.withOpacity(0.7),
    Colors.red.withOpacity(0.6),
    Colors.red.withOpacity(0.5),
    Colors.red,
  ];
}
