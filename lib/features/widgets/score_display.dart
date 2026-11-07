import 'package:flutter/material.dart';

import '../../core/constants/game_color.dart';

class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay({required this.score, super.key});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Text(
      'SCORE:  ${score.toString().padLeft(5, '0')}',
      style: const TextStyle(fontSize: 17, color: GameColor.ink),
    );
  }
}