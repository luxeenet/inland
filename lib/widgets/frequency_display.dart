import 'dart:math';
import 'package:flutter/material.dart';

class FrequencyDisplay extends StatelessWidget {
  final List<Map<String, String>> frequencies;
  final double animationValue;

  const FrequencyDisplay({
    required this.frequencies,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    final index =
        (animationValue * frequencies.length).toInt() % frequencies.length;
    final frequency = frequencies[index];

    return Center(
      child: Opacity(
        opacity: (sin(animationValue * pi * 2) + 1) / 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              frequency["place"]!,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              frequency["frequency"]!,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
