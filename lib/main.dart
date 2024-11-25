import 'package:flutter/material.dart';
//import 'package:just_audio/just_audio.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MyGalaxyRadioApp());
}

class MyGalaxyRadioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: SplashScreen(),
    );
  }
}
