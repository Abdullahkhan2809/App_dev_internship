enum Direction {
  up,
  right,
  down,
  left;

  Direction get opposite => switch (this) {
    Direction.up => Direction.down,
    Direction.right => Direction.left,
    Direction.down => Direction.up,
    Direction.left => Direction.right,
  };
}