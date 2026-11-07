import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/game_constants.dart';

class ScoreEntry {
  const ScoreEntry({required this.score, required this.achievedAt});

  final int score;
  final DateTime achievedAt;
}

class ScoreService {
  static const _scoresKey = 'snake_high_scores';

  Future<List<ScoreEntry>> getHighScores() async {
    final preferences = await SharedPreferences.getInstance();
    final entries = (preferences.getStringList(_scoresKey) ?? const <String>[])
        .map(_decode)
        .whereType<ScoreEntry>()
        .toList()
      ..sort((first, second) => second.score.compareTo(first.score));
    return entries.take(GameConstants.maxHighScores).toList();
  }

  Future<void> saveScore(int score) async {
    if (score <= 0) return;
    final entries = await getHighScores();
    entries.add(ScoreEntry(score: score, achievedAt: DateTime.now()));
    entries.sort((first, second) => second.score.compareTo(first.score));
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      _scoresKey,
      entries
          .take(GameConstants.maxHighScores)
          .map((entry) => '${entry.score}|${entry.achievedAt.toIso8601String()}')
          .toList(),
    );
  }

  Future<void> clearHighScores() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_scoresKey);
  }

  ScoreEntry? _decode(String value) {
    final parts = value.split('|');
    if (parts.length != 2) return null;
    final score = int.tryParse(parts[0]);
    final date = DateTime.tryParse(parts[1]);
    if (score == null || date == null) return null;
    return ScoreEntry(score: score, achievedAt: date);
  }
}