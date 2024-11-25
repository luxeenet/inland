import 'dart:math';
import 'package:flutter/material.dart';

class LogoDisplay extends StatelessWidget {
  final double animationValue;

  const LogoDisplay({required this.animationValue});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: (sin(animationValue * pi * 2) + 1) / 2,
        child: Image.asset(
          'assets/logo_radio.jpg', // Add your logo asset here
          height: 300,
          width: 300,
        ),
      ),
    );
  }
}
