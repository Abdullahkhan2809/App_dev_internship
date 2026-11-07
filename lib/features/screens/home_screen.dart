import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/menubutton.dart';
import '../widgets/phone_shell.dart';
import '../widgets/snake_painter.dart';
import 'game_screen.dart';
import 'score_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _select(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (_) => const GameScreen()));
        return;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (_) => const ScoreScreen()));
        return;
      case 2:
        SystemNavigator.pop();
        return;
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() => _selectedIndex = (_selectedIndex + 1) % 3);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() => _selectedIndex = (_selectedIndex + 2) % 3);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      _select(_selectedIndex);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    const labels = ['Start Game', 'High Scores', 'Exit'];
    return PhoneShell(
      child: Focus(
        autofocus: true,
        onKeyEvent: _onKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 14),
              _FramedTitle(title: 'SNAKE'),
              const SizedBox(height: 16),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 150),
                  child: const CustomPaint(
                    painter: SnakeLogoPainter(),
                    child: SizedBox.expand(),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              for (var index = 0; index < labels.length; index++)
                MenuButton(
                  label: labels[index],
                  selected: index == _selectedIndex,
                  onPressed: () => _select(index),
                ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(bottom: 12, top: 6),
                child: Column(
                  children: [
                    Text('© 2026 SNAKE GAME', style: TextStyle(fontSize: 12)),
                    SizedBox(height: 6),
                    Text(
                      'Press Enter to Select',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FramedTitle extends StatelessWidget {
  const _FramedTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 250),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Theme.of(context).colorScheme.primary
                .withValues(alpha: 0.65),
          ),
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 28, letterSpacing: 4),
        ),
      ),
    );
  }
}
