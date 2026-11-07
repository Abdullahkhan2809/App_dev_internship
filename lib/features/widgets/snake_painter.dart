import 'package:flutter/material.dart';

import '../../core/constants/game_color.dart';
import '../model/food.dart';
import '../model/position.dart';

class SnakePainter extends CustomPainter {
  const SnakePainter({
    required this.snake,
    required this.food,
    required this.columns,
    required this.rows,
  });

  final List<Position> snake;
  final Food food;
  final int columns;
  final int rows;

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / columns;
    final cellHeight = size.height / rows;
    final snakePaint = Paint()..color = GameColor.ink;
    for (final segment in snake) {
      final rect = Rect.fromLTWH(
        segment.x * cellWidth + cellWidth * 0.08,
        segment.y * cellHeight + cellHeight * 0.08,
        cellWidth * 0.84,
        cellHeight * 0.84,
      );
      canvas.drawRect(rect, snakePaint);
    }

    final foodPaint = Paint()..color = GameColor.ink;
    final foodCenter = Offset(
      (food.position.x + 0.5) * cellWidth,
      (food.position.y + 0.5) * cellHeight,
    );
    canvas.drawCircle(foodCenter, cellWidth * 0.34, foodPaint);
  }

  @override
  bool shouldRepaint(covariant SnakePainter oldDelegate) =>
      oldDelegate.snake != snake ||
      oldDelegate.food.position != food.position;
}

class SnakeLogoPainter extends CustomPainter {
  const SnakeLogoPainter();

  static const _segments = <Offset>[
    Offset(2, 0), Offset(3, 0), Offset(4, 0), Offset(5, 0),
    Offset(1, 1), Offset(2, 1), Offset(3, 1), Offset(4, 1),
    Offset(5, 1), Offset(6, 1), Offset(0, 2), Offset(1, 2),
    Offset(2, 2), Offset(5, 2), Offset(6, 2), Offset(7, 2),
    Offset(0, 3), Offset(1, 3), Offset(6, 3), Offset(7, 3),
    Offset(0, 4), Offset(1, 4), Offset(6, 4), Offset(7, 4),
    Offset(1, 5), Offset(2, 5), Offset(5, 5), Offset(6, 5),
    Offset(2, 6), Offset(3, 6), Offset(4, 6), Offset(5, 6),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    const columns = 8;
    const rows = 7;
    final cellWidth = size.width / columns;
    final cellHeight = size.height / rows;
    final paint = Paint()..color = GameColor.ink;
    for (final segment in _segments) {
      canvas.drawRect(
        Rect.fromLTWH(
          segment.dx * cellWidth + 1,
          segment.dy * cellHeight + 1,
          cellWidth - 2,
          cellHeight - 2,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SnakeLogoPainter oldDelegate) => false;
}