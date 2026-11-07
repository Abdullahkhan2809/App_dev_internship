import 'package:flutter/material.dart';

import '../../core/constants/game_color.dart';
import '../../services/score_services.dart';
import '../widgets/phone_shell.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({super.key});

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  final ScoreService _scoreService = ScoreService();
  late Future<List<ScoreEntry>> _scores;

  @override
  void initState() {
    super.initState();
    _scores = _scoreService.getHighScores();
  }

  @override
  Widget build(BuildContext context) {
    return PhoneShell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            SizedBox(
              height: 45,
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: GameColor.ink,
                      size: 18,
                    ),
                    label: const Text(
                      'BACK',
                      style: TextStyle(color: GameColor.ink),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.emoji_events_outlined, color: GameColor.ink),
                ],
              ),
            ),
            const Divider(height: 1, color: GameColor.ink),
            const SizedBox(height: 22),
            const _ScoreTitle(),
            const SizedBox(height: 24),
            Expanded(
              child: FutureBuilder<List<ScoreEntry>>(
                future: _scores,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Could not load scores: ${snapshot.error}'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(color: GameColor.ink),
                    );
                  }
                  final scores = snapshot.data!;
                  return ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final entry = index < scores.length ? scores[index] : null;
                      final selected = index == 0 && entry != null;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 15,
                        ),
                        color: selected
                            ? GameColor.ink
                            : GameColor.ink.withValues(alpha: 0.06),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 36,
                              child: Text(
                                (index + 1).toString().padLeft(2, '0'),
                                style: TextStyle(
                                  color: selected
                                      ? GameColor.highlight
                                      : GameColor.ink,
                                ),
                              ),
                            ),
                            if (selected) ...[
                              const Icon(
                                Icons.emoji_events_outlined,
                                size: 16,
                                color: GameColor.highlight,
                              ),
                              const Spacer(),
                            ] else
                              const Spacer(),
                            Text(
                              entry == null
                                  ? '-----'
                                  : entry.score.toString().padLeft(5, '0'),
                              style: TextStyle(
                                color: selected
                                    ? GameColor.highlight
                                    : GameColor.ink,
                                fontSize: 17,
                              ),
                            ),
                            if (entry != null) ...[
                              const SizedBox(width: 14),
                              Text(
                                _formatDate(entry.achievedAt),
                                style: TextStyle(
                                  color: selected
                                      ? GameColor.highlight
                                      : GameColor.subdued,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1, color: GameColor.ink),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'ESC  -  Return to Menu',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year.toString().substring(2)}';
}

class _ScoreTitle extends StatelessWidget {
  const _ScoreTitle();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: GameColor.ink.withValues(alpha: 0.65)),
        ),
      ),
      child: const Text(
        'HIGH SCORES',
        style: TextStyle(fontSize: 22, letterSpacing: 3),
      ),
    );
  }
}
