import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eztalk/utilities/tts_player.dart';

class LecturePlayingPage extends StatefulWidget {
  const LecturePlayingPage({Key? key}) : super(key: key);

  @override
  State<LecturePlayingPage> createState() => _LecturePlayingPageState();
}

class _LecturePlayingPageState extends State<LecturePlayingPage> {
  bool _isPlaying = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    TtsPlayer.initFlutterTts();
    _loadSavedText();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedText() async {
    final prefs = await SharedPreferences.getInstance();
    final savedText = prefs.getString('saved_lecture_text') ?? '';
    if (mounted) {
      setState(() {
        _textController.text = savedText;
      });
    }
  }

  Future<void> _saveText() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_lecture_text', _textController.text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('文本已保存')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('逐字稿撥放'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveText,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: '輸入要播放的文字',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            _buildPlayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
        label: Text(_isPlaying ? '停止播放' : '開始播放'),
        style: ElevatedButton.styleFrom(
          foregroundColor: _isPlaying ? Colors.orange : Colors.green,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: _isPlaying ? Colors.orange : Colors.green,
              width: 2,
            ),
          ),
        ),
        onPressed: _togglePlay,
      ),
    );
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if (_isPlaying) {
      TtsPlayer.speak(_textController.text, onComplete: () {
        setState(() {
          _isPlaying = false;
        });
        print('playback completed');
      });
    } else {
      TtsPlayer.stop();
    }
  }
}
