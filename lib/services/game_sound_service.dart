import 'package:flutter/services.dart';

class GameSoundService {
  Future<void> playFood() => SystemSound.play(SystemSoundType.click);

  Future<void> playGameOver() => SystemSound.play(SystemSoundType.alert);
}
