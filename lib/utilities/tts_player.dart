import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings.dart';

typedef CompletionCallback = void Function();

class TtsPlayer {
  static FlutterTts? _flutterTts;
  static CompletionCallback? _completionCallback;

  static Future<FlutterTts> getFlutterTts() async {
    if (_flutterTts == null) {
      await initFlutterTts();
    }
    return _flutterTts!;
  }

  static Future<void> initFlutterTts() async {
    _flutterTts = FlutterTts();
    await _loadSettings();
    _flutterTts!.setCompletionHandler(() {
      if (_completionCallback != null) {
        _completionCallback!();
      }
    });
  }

  static Future<void> _loadSettings() async {
    await Settings.loadSettings();
    String locale = Settings.voices[Settings.currentVoice] ?? "zh-TW";

    await _flutterTts!
        .setVoice({"name": Settings.currentVoice, "locale": locale});
    await _flutterTts!.setPitch(Settings.currentPitch);
    await _flutterTts!.setSpeechRate(Settings.currentRate);
  }

  static Future<void> speak(String text,
      {CompletionCallback? onComplete}) async {
    final tts = await getFlutterTts();
    _completionCallback = onComplete;
    await tts.speak(text);
  }

  static Future<void> stop() async {
    final tts = await getFlutterTts();
    await tts.stop();
  }

  static Future<void> updateSettings({
    String? voice,
    double? pitch,
    double? rate,
  }) async {
    final tts = await getFlutterTts();
    if (voice != null) {
      String locale = Settings.voices[voice] ?? "zh-TW";
      await tts.setVoice({"name": voice, "locale": locale});
    }
    if (pitch != null) {
      await tts.setPitch(pitch);
    }
    if (rate != null) {
      await tts.setSpeechRate(rate);
    }
  }
}
