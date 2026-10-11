import 'package:flutter/material.dart';

import 'features/home/presentation/screens/home_screen.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

class HangmanApp extends StatelessWidget {
  const HangmanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jogo da Forca',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9F6F0),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2C3E50)),
      ),
      home: SplashScreen(
        onLoaded: (context, answers) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => HomeScreen(answers: answers)),
          );
        },
      ),
    );
  }
}
