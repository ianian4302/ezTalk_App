import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings.dart';

class TtfPlayer {
  static FlutterTts? _flutterTts;

  static Future<FlutterTts> getFlutterTts() async {
    if (_flutterTts == null) {
      await initFlutterTts();
    }
    return _flutterTts!;
  }

  static Future<void> initFlutterTts() async {
    _flutterTts = FlutterTts();
    await _loadSettings();
  }

  static Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    String voice = prefs.getString('selectedVoice') ?? Settings.voices.keys.first;
    String locale = Settings.voices[voice] ?? "zh-TW";
    double pitch = prefs.getDouble('pitch') ?? Settings.pitch;
    double rate = prefs.getDouble('rate') ?? Settings.rate;

    await _flutterTts!.setVoice({"name": voice, "locale": locale});
    await _flutterTts!.setPitch(pitch);
    await _flutterTts!.setSpeechRate(rate);
  }

  static Future<void> speak(String text) async {
    final tts = await getFlutterTts();
    await tts.speak(text);
  }

  static Future<void> stop() async {
    final tts = await getFlutterTts();
    await tts.stop();
  }

  static Future<void> updateSettings({String? voice, double? pitch, double? rate}) async {
    final tts = await getFlutterTts();
    if (voice != null) {
      await tts.setVoice({"name": voice, "locale": "zh-TW"});
    }
    if (pitch != null) {
      await tts.setPitch(pitch);
    }
    if (rate != null) {
      await tts.setSpeechRate(rate);
    }
  }
}
