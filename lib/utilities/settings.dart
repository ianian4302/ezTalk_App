import 'package:shared_preferences/shared_preferences.dart';
import 'package:eztalk/utilities/tts_player.dart';

class Settings {
  static const Map<String, String> voices = {
    "Microsoft Zhiwei - Chinese (Traditional, Taiwan)": "zh-TW",
    "Google UK English Female": "en-GB",
    "Microsoft Yating - Chinese (Traditional, Taiwan)": "zh-TW",
    "Google UK English Male": "en-GB",
  };

  // 默認值
  static const double defaultPitch = 0.5;
  static const double defaultRate = 0.5;
  static const String defaultVoice =
      "Microsoft Zhiwei - Chinese (Traditional, Taiwan)";

  // 當前設定
  static String currentVoice = defaultVoice;
  static double currentPitch = defaultPitch;
  static double currentRate = defaultRate;

  // 從 SharedPreferences 加載設定
  static Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    currentVoice = prefs.getString('selectedVoice') ?? defaultVoice;
    currentPitch = prefs.getDouble('pitch') ?? defaultPitch;
    currentRate = prefs.getDouble('rate') ?? defaultRate;
  }

  // 保存設定到 SharedPreferences
  static Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedVoice', currentVoice);
    await prefs.setDouble('pitch', currentPitch);
    await prefs.setDouble('rate', currentRate);
  }

  // 更新設定
  static Future<void> updateSettings({
    String? voice,
    double? pitch,
    double? rate,
  }) async {
    if (voice != null) currentVoice = voice;
    if (pitch != null) currentPitch = pitch;
    if (rate != null) currentRate = rate;
    await saveSettings();
    await TtsPlayer.updateSettings(
      voice: voice,
      pitch: pitch,
      rate: rate,
    );
  }
}
