import 'package:flutter/material.dart';

import '../../core/constants/game_color.dart';
import '../engine/game_engine.dart';
import 'snake_painter.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({required this.engine, super.key});

  final GameEngine engine;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: GameColor.board,
          border: Border.all(color: GameColor.ink, width: 1.5),
        ),
        child: AnimatedBuilder(
          animation: engine,
          builder: (context, _) => CustomPaint(
            painter: SnakePainter(
              snake: engine.snake.segments,
              food: engine.food,
              columns: engine.columns,
              rows: engine.rows,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}