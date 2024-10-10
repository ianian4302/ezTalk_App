import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SeriesConnectingPage extends StatefulWidget {
  const SeriesConnectingPage({Key? key}) : super(key: key);
  @override
  State<SeriesConnectingPage> createState() => _SeriesConnectingPageState();
}

class _SeriesConnectingPageState extends State<SeriesConnectingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _isRecording = false;
  String? _recordingPath;
  final TextEditingController _nameController = TextEditingController();
  bool _isPlaying = false;

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
    if (_recordingPath != null && _nameController.text.isNotEmpty) {
      // 顯示對話框
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('提交錄音'),
            content: Text('錄音檔名稱: ${_nameController.text}'),
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
        _nameController.clear();
      });
    }
  }

  void _deleteRecording() {
    if (_recordingPath != null) {
      File(_recordingPath!).deleteSync();
      setState(() {
        _recordingPath = null;
        _nameController.clear();
      });
    }
  }

  Future<void> _startPlaying() async {
    // 實現開始播放的邏輯
    print('開始播放');
  }

  Future<void> _stopPlaying() async {
    // 實現停止播放的邏輯
    print('停止播放');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
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
                      _nameController.clear();
                    });
                  },
                ),
              ),
              const SizedBox(width: 8), // 添加一些間距
              Expanded(
                child: TextField(
                  controller: _nameController,
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
                    if (_nameController.text.isNotEmpty) {
                      print('提交: ${_nameController.text}');
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
              Expanded(child: _buildRecordButton()),
              const SizedBox(width: 16),  // 添加一些間距
              Expanded(child: _buildPlayButton()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWordSelectionArea(bool isLeft) {
    List<String> words = isLeft
        ? ['你好', '早安', '晚安', '謝謝'] // 左側的字
        : ['請問', '可以', '不可以', '再見']; // 右側的字

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
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: words
                  .map((word) => ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (isLeft) {
                              _nameController.text =
                                  word + _nameController.text;
                            } else {
                              _nameController.text =
                                  _nameController.text + word;
                            }
                          });
                        },
                        child: Text(word),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecordButton() {
    return SizedBox(
      height: 60,
      child: ElevatedButton.icon(
        icon: Icon(_isRecording ? Icons.stop : Icons.mic),
        label: Text(_isRecording ? '停止錄音' : '開始錄音'),
        style: ElevatedButton.styleFrom(
          foregroundColor: _isRecording ? Colors.red : Colors.blue,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: _isRecording ? Colors.red : Colors.blue,
              width: 2,
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            _isRecording = !_isRecording;
          });
          if (_isRecording) {
            _startRecording();
          } else {
            _stopRecording();
          }
        },
      ),
    );
  }

  Widget _buildPlayButton() {
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
            _startPlaying();
          } else {
            _stopPlaying();
          }
        },
      ),
    );
  }
}
