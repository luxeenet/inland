import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '/screens/galaxy_radio_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    Timer(const Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GalaxyRadioScreen()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Galaxy animation (background)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: GalaxyPainter(_animationController.value),
                  child: Container(),
                );
              },
            ),
          ),
          // Water wave animation
          Center(
            child: SpinKitWave(
              color: Colors.blueAccent,
              size: 80.0,
            ),
          ),
          // Black hole animation (logo and loading)
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 80,
                  backgroundImage:
                      AssetImage('assets/logo.png'), // Add your logo
                ),
                const SizedBox(height: 20),
                const Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GalaxyPainter extends CustomPainter {
  final double animationValue;

  GalaxyPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.black, Colors.deepPurple],
        stops: [0.5, 1.0],
        center: Alignment.center,
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width,
      ));
    canvas.drawRect(Offset.zero & size, paint);

    // Add black hole effect or galaxy stars
    final starPaint = Paint()..color = Colors.white.withOpacity(0.7);
    for (int i = 0; i < 200; i++) {
      final x = animationValue * i % size.width;
      final y = (size.height / 2) + (animationValue * i % 100 - 50);
      canvas.drawCircle(Offset(x, y), 2, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
