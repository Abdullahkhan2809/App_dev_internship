import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/game_color.dart';
import '../../core/utils/direction.dart';
import '../../services/game_settings_service.dart';
import '../../services/game_sound_service.dart';
import '../../services/score_services.dart';
import '../engine/game_engine.dart';
import '../widgets/game_board.dart';
import '../widgets/game_controller.dart';
import '../widgets/menubutton.dart';
import '../widgets/phone_shell.dart';
import '../widgets/score_display.dart';
import 'score_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  final GameEngine _engine = GameEngine();
  final ScoreService _scoreService = ScoreService();
  final GameSettingsService _settingsService = GameSettingsService();
  final GameSoundService _soundService = GameSoundService();
  bool _scoreSaved = false;
  bool _soundEnabled = true;
  bool _soundSettingLoaded = false;
  Offset? _dragStart;
  int _lastObservedScore = 0;
  GameStatus _lastObservedStatus = GameStatus.ready;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _engine.addListener(_handleEngineChange);
    unawaited(_loadSoundSetting());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _engine.removeListener(_handleEngineChange);
    _engine.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed &&
        _engine.status == GameStatus.playing) {
      _engine.pause();
    }
  }

  void _handleEngineChange() {
    final ateFood = _engine.score > _lastObservedScore;
    final gameEnded =
        _engine.status == GameStatus.gameOver &&
        _lastObservedStatus != GameStatus.gameOver;
    _lastObservedScore = _engine.score;
    _lastObservedStatus = _engine.status;

    if (_engine.status == GameStatus.gameOver && !_scoreSaved) {
      _scoreSaved = true;
      unawaited(_saveScore(_engine.score));
    }
    if (_soundEnabled && ateFood) unawaited(_playSound(food: true));
    if (_soundEnabled && gameEnded) unawaited(_playSound(food: false));
    if (mounted) setState(() {});
  }

  Future<void> _loadSoundSetting() async {
    try {
      final enabled = await _settingsService.isSoundEnabled();
      if (!mounted) return;
      setState(() {
        _soundEnabled = enabled;
        _soundSettingLoaded = true;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _soundSettingLoaded = true);
      _showError('Could not load sound setting: $error');
    }
  }

  Future<void> _toggleSound() async {
    final enabled = !_soundEnabled;
    try {
      await _settingsService.setSoundEnabled(enabled);
      if (!mounted) return;
      setState(() => _soundEnabled = enabled);
    } catch (error) {
      if (!mounted) return;
      _showError('Could not save sound setting: $error');
    }
  }

  Future<void> _playSound({required bool food}) async {
    try {
      if (food) {
        await _soundService.playFood();
      } else {
        await _soundService.playGameOver();
      }
    } catch (error) {
      if (mounted) _showError('Could not play sound effect: $error');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _saveScore(int score) async {
    try {
      await _scoreService.saveScore(score);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not save score: $error')));
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.keyW) {
      _engine.changeDirection(Direction.up);
    } else if (key == LogicalKeyboardKey.arrowRight ||
        key == LogicalKeyboardKey.keyD) {
      _engine.changeDirection(Direction.right);
    } else if (key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.keyS) {
      _engine.changeDirection(Direction.down);
    } else if (key == LogicalKeyboardKey.arrowLeft ||
        key == LogicalKeyboardKey.keyA) {
      _engine.changeDirection(Direction.left);
    } else if (key == LogicalKeyboardKey.keyP ||
        key == LogicalKeyboardKey.space ||
        key == LogicalKeyboardKey.escape) {
      _engine.pause();
    } else if (key == LogicalKeyboardKey.enter &&
        _engine.status == GameStatus.gameOver) {
      _scoreSaved = false;
      _engine.reset();
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  void _handleSwipe(Offset end) {
    final start = _dragStart;
    if (start == null) return;
    final delta = end - start;
    if (delta.distance < 18) {
      if (_engine.status == GameStatus.ready) _engine.start();
      return;
    }
    if (delta.dx.abs() > delta.dy.abs()) {
      _engine.changeDirection(delta.dx > 0 ? Direction.right : Direction.left);
    } else {
      _engine.changeDirection(delta.dy > 0 ? Direction.down : Direction.up);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PhoneShell(
      child: Focus(
        autofocus: true,
        onKeyEvent: _onKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              _buildHeader(),
              const Divider(height: 1, color: GameColor.ink),
              const SizedBox(height: 10),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final boardSize = math.min(
                      constraints.maxWidth,
                      math.min(390.0, constraints.maxHeight - 190),
                    );
                    final safeBoardSize = math.max(180.0, boardSize);
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Center(
                            child: SizedBox(
                              width: safeBoardSize,
                              child: GestureDetector(
                                onPanStart: (details) =>
                                    _dragStart = details.localPosition,
                                onPanEnd: (details) =>
                                    _handleSwipe(details.localPosition),
                                onTap: () {
                                  if (_engine.status == GameStatus.ready) {
                                    _engine.start();
                                  }
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    GameBoard(engine: _engine),
                                    if (_engine.status != GameStatus.playing)
                                      _buildBoardOverlay(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (_engine.status == GameStatus.playing ||
                              _engine.status == GameStatus.ready)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GameController(
                                  onDirection: _engine.changeDirection,
                                ),
                                const SizedBox(height: 32),
                                GamePauseControl(
                                  onPressed:
                                      _engine.status == GameStatus.playing
                                      ? _engine.pause
                                      : null,
                                ),
                              ],
                            )
                          else if (_engine.status == GameStatus.paused)
                            MenuButton(
                              label: 'Resume',
                              selected: true,
                              onPressed: _engine.pause,
                            )
                          else
                            _buildGameOverActions(),
                          const SizedBox(height: 8),
                          Text(
                            _engine.status == GameStatus.ready
                                ? 'Arrow Keys to Start'
                                : _engine.status == GameStatus.paused
                                ? 'Press P to Resume'
                                : _engine.status == GameStatus.playing
                                ? 'Swipe or use arrow keys to steer'
                                : 'Press Enter to Play Again',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 45,
      child: Row(
        children: [
          Expanded(child: ScoreDisplay(score: _engine.score)),
          IconButton(
            tooltip: _soundEnabled ? 'Mute sound' : 'Enable sound',
            onPressed: _soundSettingLoaded ? _toggleSound : null,
            icon: Icon(
              _soundEnabled ? Icons.volume_up : Icons.volume_off,
              color: GameColor.ink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardOverlay() {
    final isGameOver = _engine.status == GameStatus.gameOver;
    final isPaused = _engine.status == GameStatus.paused;
    return Positioned.fill(
      child: ColoredBox(
        color: GameColor.screen.withValues(alpha: 0.84),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isGameOver
                      ? 'GAME OVER'
                      : isPaused
                      ? 'PAUSED'
                      : 'READY?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, letterSpacing: 2),
                ),
                const SizedBox(height: 16),
                Text(
                  isGameOver
                      ? 'YOUR SCORE\n${_engine.score.toString().padLeft(5, '0')}'
                      : isPaused
                      ? 'Press P to continue'
                      : 'Use Arrow Keys\nto Start and Play',
                  textAlign: TextAlign.center,
                  style: const TextStyle(height: 1.7),
                ),
                if (!isGameOver && !isPaused) ...[
                  const SizedBox(height: 8),
                  const Text('Press P to Pause'),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverActions() {
    return Column(
      children: [
        MenuButton(
          label: 'Play Again',
          selected: true,
          trailing: const Icon(Icons.refresh, color: GameColor.highlight),
          onPressed: () {
            _scoreSaved = false;
            _engine.reset();
          },
        ),
        MenuButton(
          label: 'Main Menu',
          trailing: const Icon(Icons.home_outlined, color: GameColor.ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
        MenuButton(
          label: 'High Scores',
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute<void>(builder: (_) => const ScoreScreen())),
        ),
      ],
    );
  }
}
