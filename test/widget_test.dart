import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_game_workshop/app/app.dart';
import 'package:snake_game_workshop/core/utils/direction.dart';
import 'package:snake_game_workshop/features/engine/game_engine.dart';
import 'package:snake_game_workshop/features/model/food.dart';
import 'package:snake_game_workshop/features/model/position.dart';
import 'package:snake_game_workshop/features/widgets/game_controller.dart';
import 'package:snake_game_workshop/services/game_settings_service.dart';
import 'package:snake_game_workshop/services/score_services.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('home screen opens a playable game', (tester) async {
    await tester.pumpWidget(const SnakeGameApp());

    expect(find.text('SNAKE'), findsOneWidget);
    expect(find.text('Start Game'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.text('SNAKE')))
          .textTheme
          .bodyMedium
          ?.fontFamily,
      'GeistPixel_regular',
    );

    await tester.tap(find.text('Start Game'));
    await tester.pumpAndSettle();

    expect(find.text('READY?'), findsOneWidget);
    expect(find.text('SCORE:  00000'), findsOneWidget);
    expect(find.text('PAUSE'), findsOneWidget);
    expect(find.text('ESC / P'), findsOneWidget);
    expect(find.byType(GamePauseControl), findsOneWidget);
  });

  test('eating food grows the snake and awards points', () {
    final engine = GameEngine();
    engine.food = Food(engine.snake.head.move(1, 0));
    engine.start();

    engine.tick();

    expect(engine.score, 10);
    expect(engine.snake.segments, hasLength(4));
    expect(engine.snake.segments, isNot(contains(engine.food.position)));
    engine.dispose();
  });

  test('direction changes reject a 180-degree turn', () {
    final engine = GameEngine();
    engine.start();

    engine.changeDirection(Direction.left);
    engine.tick();
    expect(engine.snake.direction, Direction.right);

    engine.changeDirection(Direction.up);
    engine.tick();
    expect(engine.snake.direction, Direction.up);
    engine.changeDirection(Direction.down);
    engine.tick();
    expect(engine.snake.direction, Direction.up);
    engine.dispose();
  });

  test('wall collision ends the game', () {
    final engine = GameEngine(columns: 5, rows: 5);
    engine.snake.segments = const [
      Position(4, 2),
      Position(3, 2),
      Position(2, 2),
    ];
    engine.start();

    engine.tick();

    expect(engine.status, GameStatus.gameOver);
    engine.dispose();
  });

  test('self collision ends the game', () {
    final engine = GameEngine(columns: 6, rows: 6);
    engine.snake.segments = const [
      Position(2, 2),
      Position(2, 3),
      Position(3, 3),
      Position(3, 2),
      Position(4, 2),
    ];
    engine.start();

    engine.tick();

    expect(engine.status, GameStatus.gameOver);
    engine.dispose();
  });

  test('pause, resume, and restart keep lifecycle state consistent', () {
    final engine = GameEngine();
    engine.start();
    expect(engine.status, GameStatus.playing);

    engine.pause();
    expect(engine.status, GameStatus.paused);

    engine.pause();
    expect(engine.status, GameStatus.playing);

    engine.reset();
    expect(engine.status, GameStatus.ready);
    expect(engine.score, 0);
    engine.dispose();
  });

  test('high scores and sound setting persist', () async {
    final scores = ScoreService();
    await scores.saveScore(30);
    await scores.saveScore(10);

    final savedScores = await scores.getHighScores();
    expect(savedScores.map((entry) => entry.score), [30, 10]);

    final settings = GameSettingsService();
    expect(await settings.isSoundEnabled(), isTrue);
    await settings.setSoundEnabled(false);
    expect(await settings.isSoundEnabled(), isFalse);
  });

  testWidgets('home menu has no settings screen', (tester) async {
    await tester.pumpWidget(const SnakeGameApp());

    expect(find.text('Start Game'), findsOneWidget);
    expect(find.text('High Scores'), findsOneWidget);
    expect(find.text('Exit'), findsOneWidget);
    expect(find.text('Settings'), findsNothing);
  });
}
