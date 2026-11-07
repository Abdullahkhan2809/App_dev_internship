import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/game_color.dart';

ThemeData buildGameTheme() {
  final fontFamily = GoogleFonts.geistPixel().fontFamily!;
  final pixelTextTheme = ThemeData.light().textTheme.apply(
    fontFamily: fontFamily,
    bodyColor: GameColor.ink,
    displayColor: GameColor.ink,
  );

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: GameColor.backdrop,
    colorScheme: ColorScheme.fromSeed(
      seedColor: GameColor.highlight,
      brightness: Brightness.light,
      surface: GameColor.screen,
      primary: GameColor.ink,
    ),
    fontFamily: fontFamily,
    textTheme: pixelTextTheme,
    primaryTextTheme: pixelTextTheme,
  );
}
