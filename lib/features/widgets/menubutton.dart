import 'package:flutter/material.dart';

import '../../core/constants/game_color.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    required this.label,
    required this.onPressed,
    this.selected = false,
    this.trailing,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final bool selected;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? GameColor.ink : Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected ? GameColor.highlight : GameColor.ink,
                      fontSize: 17,
                    ),
                  ),
                ),
                trailing ??
                    Icon(
                      selected ? Icons.chevron_right : null,
                      color: GameColor.highlight,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}