import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../core/constants/game_constants.dart';
import '../../core/utils/direction.dart';
import '../model/food.dart';
import '../model/position.dart';
import '../model/snake.dart';
import 'collision_detector.dart';

enum GameStatus {
  ready,
  playing,
  paused,
  gameOver;

  static const running = playing;
}

class GameEngine extends ChangeNotifier {
  GameEngine({this.columns = GameConstants.columns, this.rows = GameConstants.rows})
    : _random = Random() {
    reset();
  }

  final int columns;
  final int rows;
  final Random _random;
  final CollisionDetector _collisionDetector = const CollisionDetector();
  Timer? _timer;
  Direction? _queuedDirection;

  late Snake snake;
  late Food food;
  GameStatus status = GameStatus.ready;
  int score = 0;

  void reset() {
    _timer?.cancel();
    snake = Snake(startX: columns ~/ 2, startY: rows ~/ 2);
    _queuedDirection = null;
    score = 0;
    status = GameStatus.ready;
    _placeFood();
    notifyListeners();
  }

  void start() {
    if (status == GameStatus.gameOver || status == GameStatus.playing) return;
    status = GameStatus.playing;
    _startTimer();
    notifyListeners();
  }

  void pause() {
    if (status == GameStatus.playing) {
      _timer?.cancel();
      status = GameStatus.paused;
      notifyListeners();
    } else if (status == GameStatus.paused) {
      start();
    }
  }

  void changeDirection(Direction direction) {
    if (status == GameStatus.ready) {
      if (direction != snake.direction.opposite &&
          direction != snake.direction) {
        _queuedDirection = direction;
      }
      start();
      return;
    }
    if (direction == snake.direction.opposite ||
        direction == snake.direction ||
        _queuedDirection != null) {
      return;
    }
    _queuedDirection = direction;
  }

  void tick() {
    if (status != GameStatus.playing) return;
    snake.direction = _queuedDirection ?? snake.direction;
    _queuedDirection = null;
    final nextHead = switch (snake.direction) {
      Direction.up => snake.head.move(0, -1),
      Direction.right => snake.head.move(1, 0),
      Direction.down => snake.head.move(0, 1),
      Direction.left => snake.head.move(-1, 0),
    };
    final growing = nextHead == food.position;
    final nextBody = [nextHead, ...snake.segments];
    if (_collisionDetector.hitsWall(nextHead, columns, rows) ||
        _collisionDetector.hitsBody(nextBody, growing: growing)) {
      _timer?.cancel();
      status = GameStatus.gameOver;
      notifyListeners();
      return;
    }

    snake.advance(grow: growing);
    if (growing) {
      score += 10;
      if (!_placeFood()) {
        _timer?.cancel();
        status = GameStatus.gameOver;
        notifyListeners();
        return;
      }
      _startTimer();
    }
    notifyListeners();
  }

  bool _placeFood() {
    final openCells = <Position>[
      for (var y = 0; y < rows; y++)
        for (var x = 0; x < columns; x++)
          if (!snake.segments.contains(Position(x, y))) Position(x, y),
    ];
    if (openCells.isEmpty) return false;
    food = Food(openCells[_random.nextInt(openCells.length)]);
    return true;
  }

  void _startTimer() {
    _timer?.cancel();
    final interval = max(
      GameConstants.minimumSpeed,
      GameConstants.initialSpeed -
          score ~/ 10 * GameConstants.speedStep,
    );
    _timer = Timer.periodic(Duration(milliseconds: interval), (_) => tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}