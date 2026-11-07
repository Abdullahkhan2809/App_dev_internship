import '../model/position.dart';

class CollisionDetector {
  const CollisionDetector();

  bool hitsWall(Position position, int columns, int rows) =>
      position.x < 0 ||
      position.x >= columns ||
      position.y < 0 ||
      position.y >= rows;

  bool hitsBody(List<Position> body, {bool growing = false}) {
    final occupiedLength = growing ? body.length - 1 : body.length - 2;
    return body.skip(1).take(occupiedLength).contains(body.first);
  }
}