import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:eztalk/utilities/tts_player.dart';
import 'package:eztalk/api/eztalk_api.dart';
import 'package:eztalk/widgets/records/play_button.dart';
import 'package:eztalk/widgets/records/record_button.dart';

class SeriesConnectingPage extends StatefulWidget {
  const SeriesConnectingPage({Key? key}) : super(key: key);
  @override
  State<SeriesConnectingPage> createState() => _SeriesConnectingPageState();
}

class _SeriesConnectingPageState extends State<SeriesConnectingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final EztalkApi api = EztalkApi();
  Future<SeriesConnecting>? futureSeriesConnecting;

  bool _isRecording = false;
  String? _recordingPath;
  final TextEditingController _translationText = TextEditingController();

  List<String> wordsleft = [];
  List<String> wordsright = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 0; // 預設選中第一個頁面
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
  }

  Future<void> _startRecording() async {
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    setState(() {
      _isRecording = false;
    });
  }

  Future<void> _submitRecording() async {
    if (_recordingPath != null && _translationText.text.isNotEmpty) {
      // 顯示對話框
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('提交錄音'),
            content: Text('錄音檔名稱: ${_translationText.text}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('確認'),
              ),
            ],
          );
        },
      );
      // Reset after submission
      setState(() {
        _recordingPath = null;
        _translationText.clear();
      });
    }
  }

  Future<void> _startPlaying() async {
    // 實現開始播放的邏輯
    print(_translationText.text);
    TtsPlayer.speak(_translationText.text);
  }

  Future<void> _stopPlaying() async {
    // 實現停止播放的邏輯
    print('停止播放');
    TtsPlayer.stop();
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

  @override
  void dispose() {
    _tabController.dispose();
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
                      print('提交: ${_translationText.text}');
                      _fetchSeriesConnecting(_translationText.text);
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
                child: RecordButton(
                  isRecording: _isRecording,
                  onStartRecording: _startRecording,
                  onStopRecording: _stopRecording,
                ),
              ),
              const SizedBox(width: 16), // 添加一些間距
              Expanded(child: PlayButton(translationText: _translationText)),
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
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero, // 设置为矩形
                            ),
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
}
