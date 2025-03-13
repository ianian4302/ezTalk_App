import 'package:flutter/material.dart';
import 'package:eztalk/api/eztalk_api.dart';
import 'package:eztalk/utilities/recorder.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistorySeriesPage extends StatefulWidget {
  const HistorySeriesPage({Key? key}) : super(key: key);
  @override
  State<HistorySeriesPage> createState() => _HistorySeriesPageState();
}

class _HistorySeriesPageState extends State<HistorySeriesPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final Recorder recorder =
      Recorder(); // Create an instance of the new Recorder class
  final EztalkApi api = EztalkApi();

  String? recordingPath;
  bool isRecording = false;

  final TextEditingController input = TextEditingController();

  List<String> historyWords = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchHistorySeries(String input) async {
    try {
      final result = await api.historySeriesGet(input);
      setState(() {
        historyWords = result;
      });
    } catch (e) {
      print('Error fetching series connecting: $e');
    }
  }

  @override
  void dispose() {
    input.dispose();
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
                      input.clear();
                    });
                  },
                ),
              ),
              const SizedBox(width: 8), // 添加一些間距
              Expanded(
                child: TextField(
                  controller: input,
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
                    if (input.text.isNotEmpty) {
                      print('提交: ${input.text}');
                      // TtsPlayer.getLanguage();
                      _fetchHistorySeries(input.text);
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
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _recordingButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWordSelectionArea(bool isLeft) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('歷史語句',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                children: historyWords
                    .map((word) => ElevatedButton(
                          onPressed: () {
                            setState(() {
                              input.text = word;
                            });
                            _fetchHistorySeries(input.text);
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
              _fetchHistorySeries(result);
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
}
