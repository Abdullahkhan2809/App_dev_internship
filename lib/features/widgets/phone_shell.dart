import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/game_color.dart';

class PhoneShell extends StatelessWidget {
  const PhoneShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GameColor.backdrop,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = math.min(constraints.maxHeight, 880.0);
            return Center(
              child: Container(
                width: math.min(constraints.maxWidth - 24, 520.0),
                height: height,
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: GameColor.screen,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: GameColor.frame, width: 5),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: GameColor.ink.withValues(alpha: 0.3),
                    ),
                  ),
                  child: child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
