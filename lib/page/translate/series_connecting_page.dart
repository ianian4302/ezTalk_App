import 'package:flutter/material.dart';
import 'package:eztalk/api/eztalk_api.dart';
import 'package:eztalk/utilities/recorder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eztalk/utilities/tts_player.dart';

class SeriesConnectingPage extends StatefulWidget {
  const SeriesConnectingPage({Key? key}) : super(key: key);
  @override
  State<SeriesConnectingPage> createState() => _SeriesConnectingPageState();
}

class _SeriesConnectingPageState extends State<SeriesConnectingPage> {
  bool _isPlaying = false;
  final User? user = FirebaseAuth.instance.currentUser;
  final Recorder recorder =
      Recorder(); // Create an instance of the new Recorder class
  final EztalkApi api = EztalkApi();

  String? recordingPath;
  bool isRecording = false;

  final TextEditingController _translationText = TextEditingController();

  List<String> wordsleft = [];
  List<String> wordsright = [];

  @override
  void initState() {
    super.initState();
    _translationText.addListener(() {
      _fetchSeriesConnecting(_translationText.text);
    });
  }

  Future<void> _fetchSeriesConnecting(String input) async {
    try {
      final result = await api.seriesConnectingGet(input);
      setState(() {
        wordsleft = result.frontWords;
        wordsright = result.backWords;
      });
    } catch (e) {
      print('Error fetching series connecting: $e');
    }
  }

  Future<void> _confirmConnecting(String input, String filename) async {
    //  TODO: 確認連接
    try {
      final result =
          await api.feedback(user?.displayName ?? 'NoName', input, filename);
      print('Feedback result: $result');
    } catch (e) {
      print('Error fetching series connecting: $e');
    }
  }

  @override
  void dispose() {
    _translationText.removeListener(() {});
    _translationText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      _translationText.clear();
                    });
                  },
                ),
              ),
              const SizedBox(width: 8), // 添加一些間距
              Expanded(
                child: TextField(
                  controller: _translationText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                    labelText: '',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8), // 添加一些間距
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_translationText.text.isNotEmpty) {
                      print('confirm: ${_translationText.text}');
                      _confirmConnecting(
                          _translationText.text, recordingPath ?? 'NoName');
                      setState(() {
                        _translationText.clear();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildWordSelectionArea(true),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildWordSelectionArea(false),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _recordingButton(),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _buildPlayButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWordSelectionArea(bool isLeft) {
    final words = isLeft ? wordsleft : wordsright;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(isLeft ? '前綴' : '後綴',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 4,
                runSpacing: 4, // 添加一些垂直间距
                children: words
                    .map((word) => ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (isLeft) {
                                _translationText.text =
                                    word + _translationText.text;
                              } else {
                                _translationText.text =
                                    _translationText.text + word;
                              }
                            });
                            // _fetchSeriesConnecting(_translationText.text);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                          ),
                          child: Text(word),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _recordingButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (isRecording) {
          String? filepath = await recorder.stopRecording();
          if (filepath != null) {
            setState(() {
              isRecording = false;
              recordingPath = filepath;
            });
            print('Recorded at $filepath');
            if (recordingPath != null) {
              var result = await api.uploadFile(
                  recordingPath!, user?.displayName ?? 'NoName');
              print('Upload result: $result');
              _translationText.text = result;
              _fetchSeriesConnecting(result);
            }
          }
        } else {
          String? filepath = await recorder.startRecording();
          if (filepath != null) {
            setState(() {
              isRecording = true;
              recordingPath = null;
            });
          }
        }
      },
      child: Icon(isRecording ? Icons.stop : Icons.mic),
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

  void _togglePlay() async {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if (_isPlaying) {
      TtsPlayer.speak(_translationText.text, onComplete: () {
        setState(() {
          _isPlaying = false;
        });
        print('playback completed');
      });
    } else {
      TtsPlayer.stop();
    }
    final feedback_data = {
      'sentence': _translationText.text,
      'isPlaying': _isPlaying,
    };
    await api.confirmAudio(_translationText.text);
  }
}
