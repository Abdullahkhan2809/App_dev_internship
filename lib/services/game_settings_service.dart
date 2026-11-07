import 'package:shared_preferences/shared_preferences.dart';

class GameSettingsService {
  static const _soundEnabledKey = 'snake_sound_enabled';

  Future<bool> isSoundEnabled() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_soundEnabledKey) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_soundEnabledKey, enabled);
  }
}
