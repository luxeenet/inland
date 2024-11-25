import 'dart:math';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background galaxy animation
          Positioned.fill(
            child: CustomPaint(
              painter: GalaxyPainter(0.5), // Static galaxy effect
              child: Container(),
            ),
          ),
          // Dynamic black hole animation
          Positioned.fill(
            child: AnimatedBuilder(
              animation: Listenable.merge([CustomBlackHoleController()]),
              builder: (context, child) {
                return CustomPaint(
                  painter: BlackHolePainter(CustomBlackHoleController().value),
                  child: Container(),
                );
              },
            ),
          ),
          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'About App developer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'developed by Emmanuel Raymond. '
                  ' im app , website, systems developer'
                  '     this app stream inland FM .',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back to Galaxy Player'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom Painter for the Galaxy background animation
class GalaxyPainter extends CustomPainter {
  final double animationValue;

  GalaxyPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.blueAccent, Colors.black],
        stops: [0.5, 1.0],
        center: Alignment.center,
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ));

    canvas.drawRect(Offset.zero & size, paint);

    final starPaint = Paint()..color = Colors.white.withOpacity(0.7);
    final random = Random();

    // Drawing stars with some animation for the galaxy
    for (int i = 0; i < 200; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 3;

      double moveX = sin(animationValue * pi + i) * 5;
      double moveY = cos(animationValue * pi + i) * 5;

      canvas.drawCircle(Offset(x + moveX, y + moveY), radius, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom Painter for the black hole animation
class BlackHolePainter extends CustomPainter {
  final double scaleFactor;

  BlackHolePainter(this.scaleFactor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // Draw the black hole effect
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      100 * scaleFactor,
      paint,
    );

    final ringPaint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    // Draw a rotating ring around the black hole
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      120 * scaleFactor,
      ringPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Animation Controller for Black Hole dynamic scaling
class CustomBlackHoleController extends ChangeNotifier {
  double _value = 1.0;
  double get value => _value;

  CustomBlackHoleController() {
    _animateBlackHole();
  }

  void _animateBlackHole() async {
    while (true) {
      _value = 1.0 + (sin(DateTime.now().millisecondsSinceEpoch / 1000) * 0.3);
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }
}
