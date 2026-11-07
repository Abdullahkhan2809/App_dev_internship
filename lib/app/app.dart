import 'package:flutter/material.dart';

import '../features/screens/home_screen.dart';
import 'theme.dart';

class SnakeGameApp extends StatelessWidget {
  const SnakeGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake',
      debugShowCheckedModeBanner: false,
      theme: buildGameTheme(),
      home: const HomeScreen(),
    );
  }
}
