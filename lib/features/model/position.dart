class Position {
  const Position(this.x, this.y);

  final int x;
  final int y;

  Position move(int dx, int dy) => Position(x + dx, y + dy);

  @override
  bool operator ==(Object other) =>
      other is Position && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}