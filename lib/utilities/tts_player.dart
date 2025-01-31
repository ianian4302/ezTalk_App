import 'package:flutter_tts/flutter_tts.dart';
import 'settings.dart';

typedef CompletionCallback = void Function();

class TtsPlayer {
  static FlutterTts? _flutterTts;
  static CompletionCallback? _completionCallback;

  static Future<Map<String, String>> getLanguage() async {
    final tts = FlutterTts();
    final voices = await tts.getVoices;
    Map<String, String> voicesMap = {};
    // for (var voice in voices) {
    //   print('Voice: ${voice['name']}, Locale: ${voice['locale']}');
    //   voicesMap[voice['name']] = voice['locale'];
    // }
    return voicesMap;
  }

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
    final voice = Settings.currentVoice;

    await _flutterTts!.setVoice({"name": voice, "locale": "zh-TW"});
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
      final voice = Settings.currentVoice;
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
