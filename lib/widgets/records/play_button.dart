import 'package:flutter/material.dart';
import 'package:eztalk/utilities/tts_player.dart';

class PlayButton extends StatefulWidget {
  final TextEditingController translationText;

  const PlayButton({Key? key, required this.translationText}) : super(key: key);

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
        onPressed: () {
          setState(() {
            _isPlaying = !_isPlaying;
          });
          if (_isPlaying) {
            TtsPlayer.speak(widget.translationText.text, onComplete: () {
              setState(() {
                _isPlaying = false;
              });
              print('playback completed');
            });
          } else {
            TtsPlayer.stop();
          }
        },
      ),
    );
  }
}
