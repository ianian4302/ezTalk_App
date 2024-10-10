import 'package:flutter/material.dart';
import 'package:eztalk/utilities/Ttf_player.dart';

class LecturePlayingPage extends StatefulWidget {
  const LecturePlayingPage({Key? key}) : super(key: key);

  @override
  State<LecturePlayingPage> createState() => _LecturePlayingPageState();
}

class _LecturePlayingPageState extends State<LecturePlayingPage> {
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    TtfPlayer.initFlutterTts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('逐字稿撥放頁面'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _togglePlay,
              child: Text(_isPlaying ? '停止播放' : '開始播放'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if (_isPlaying) {
      TtfPlayer.speak("Hello, world! 你好，世界！");
    } else {
      TtfPlayer.stop();
    }
  }
}
