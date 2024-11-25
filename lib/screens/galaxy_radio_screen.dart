import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '/widgets/frequency_display.dart';
import '/widgets/logo_display.dart';
import '/widgets/futuristic_button.dart';
import '/screens/about_screen.dart';

class GalaxyRadioScreen extends StatefulWidget {
  @override
  _GalaxyRadioScreenState createState() => _GalaxyRadioScreenState();
}

class _GalaxyRadioScreenState extends State<GalaxyRadioScreen>
    with TickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  final String streamUrl = 'https://stream.zeno.fm/g3ecvxsvr6nuv';

  late AnimationController _starController;
  late AnimationController _frequencyController;
  late AnimationController _logoController;

  final List<Map<String, String>> _frequencies = [
    //{"place": "Tabora", "frequency": "55.7 MHz"},
    {"place": "Mwanza", "frequency": "93.3 MHz"},
    {"place": "Simiyu", "frequency": "96.3 MHz"},
    {"place": "Shinyanga", "frequency": "100.3 MHz"},

    ///{"place": "Dodoma", "frequency": "100.3 MHz"},
  ];

  @override
  void initState() {
    super.initState();

    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    _frequencyController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _starController.dispose();
    _frequencyController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
    } else {
      await _audioPlayer.setUrl(streamUrl);
      _audioPlayer.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _starController,
            builder: (context, child) {
              return CustomPaint(
                painter: GalaxyPainter(_starController.value, _isPlaying),
                child: Container(),
              );
            },
          ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Frequencies displayed above the logo
                AnimatedBuilder(
                  animation: _frequencyController,
                  builder: (context, child) {
                    return FrequencyDisplay(
                      frequencies: _frequencies,
                      animationValue: _frequencyController.value,
                    );
                  },
                ),
                const SizedBox(height: 20), // Space between frequency and logo

                // Logo displayed below the frequencies
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return LogoDisplay(animationValue: _logoController.value);
                  },
                ),
              ],
            ),
          ),

          // Content: Frequencies and Logo
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Frequencies displayed above the logo
                AnimatedBuilder(
                  animation: _frequencyController,
                  builder: (context, child) {
                    return FrequencyDisplay(
                      frequencies: _frequencies,
                      animationValue: _frequencyController.value,
                    );
                  },
                ),
                const SizedBox(height: 20), // Space between frequency and logo

                // Logo displayed below the frequencies
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return LogoDisplay(animationValue: _logoController.value);
                  },
                ),
              ],
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CustomPaint(painter: CustomFrequencyPainter()),
              ),
              IconButton(
                icon: Icon(
                  _isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  size: 80,
                  color: Colors.white,
                ),
                onPressed: togglePlayPause,
              ),
              const SizedBox(height: 20),
              const Text(
                'inland FM',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          //Futuristic About button at the top right
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FuturisticButton(
                onPressed: () {
                  // Navigate to About Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutScreen()),
                  );
                },
                label: "About", // Label for the button
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GalaxyPainter extends CustomPainter {
  final double animationValue;
  final bool isPlaying;

  GalaxyPainter(this.animationValue, this.isPlaying);

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

    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 3;

      double moveX = isPlaying ? sin(animationValue * pi + i) * 5 : 0;
      double moveY = isPlaying ? cos(animationValue * pi + i) * 5 : 0;

      canvas.drawCircle(Offset(x + moveX, y + moveY), radius, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CustomFrequencyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.pinkAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    final random = Random();

    for (int i = 0; i < size.width.toInt(); i++) {
      final x = i.toDouble();
      final y = size.height / 2 + random.nextDouble() * 50 * sin(i * 0.1);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
