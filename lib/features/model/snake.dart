import '../../core/constants/game_constants.dart';
import '../../core/utils/direction.dart';
import 'position.dart';

class Snake {
  Snake({
    int startX = GameConstants.columns ~/ 2,
    int startY = GameConstants.rows ~/ 2,
  }) : segments = List.generate(
         GameConstants.initialLength,
         (index) => Position(startX - index, startY),
       );

  List<Position> segments;
  Direction direction = Direction.right;

  Position get head => segments.first;

  List<Position> advance({bool grow = false}) {
    final delta = switch (direction) {
      Direction.up => const (0, -1),
      Direction.right => const (1, 0),
      Direction.down => const (0, 1),
      Direction.left => const (-1, 0),
    };
    final next = head.move(delta.$1, delta.$2);
    final updated = <Position>[next, ...segments];
    if (!grow) updated.removeLast();
    segments = updated;
    return segments;
  }
}