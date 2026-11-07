import 'package:flutter/material.dart';

import '../../core/constants/game_color.dart';
import '../../core/utils/direction.dart';

class GameController extends StatelessWidget {
  const GameController({required this.onDirection, super.key});

  final ValueChanged<Direction> onDirection;

  @override
  Widget build(BuildContext context) {
    Widget button(Direction direction, IconData icon) => SizedBox(
      width: 48,
      height: 44,
      child: OutlinedButton(
        onPressed: () => onDirection(direction),
        style: OutlinedButton.styleFrom(
          foregroundColor: GameColor.ink,
          side: BorderSide(color: GameColor.ink.withValues(alpha: 0.45)),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Icon(icon, size: 22),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        button(Direction.up, Icons.keyboard_arrow_up),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            button(Direction.left, Icons.keyboard_arrow_left),
            const SizedBox(width: 48, height: 44),
            button(Direction.right, Icons.keyboard_arrow_right),
          ],
        ),
        button(Direction.down, Icons.keyboard_arrow_down),
      ],
    );
  }
}

class GamePauseControl extends StatelessWidget {
  const GamePauseControl({required this.onPressed, super.key});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 76,
          height: 76,
          child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: GameColor.ink,
              side: BorderSide(color: GameColor.ink.withValues(alpha: 0.55)),
              padding: const EdgeInsets.all(6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pause, size: 24),
                const Text('PAUSE', style: TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Text('ESC / P', style: TextStyle(fontSize: 10)),
      ],
    );
  }
}
