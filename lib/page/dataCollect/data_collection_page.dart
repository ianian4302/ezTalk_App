import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:eztalk/utilities/design.dart';

class DataCollectionPage extends StatefulWidget {
  const DataCollectionPage({Key? key}) : super(key: key);
  @override
  State<DataCollectionPage> createState() => _DataCollectionPageState();
}

class _DataCollectionPageState extends State<DataCollectionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _isRecording = false;
  String? _recordingPath;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 0; // 預設選中第一個頁面
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    // 處理權限狀態
  }

  Future<void> _startRecording() async {
    setState(() {
      _isRecording = true;
    });
    // 實現開始錄音的邏輯
  }

  Future<void> _stopRecording() async {
    setState(() {
      _isRecording = false;
    });
    // 實現停止錄音的邏輯
  }

  Future<void> _submitRecording() async {
    if (_recordingPath != null && _nameController.text.isNotEmpty) {
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

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('資料蒐集'),
          backgroundColor: Design.secondaryColor,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: '單句錄音'),
              Tab(text: '整句錄音'),
              Tab(text: '歷史錄音'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildRecordingPage('單句'),
            _buildRecordingPage('整句'),
            _buildHistoryPage(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordingPage(String type) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: '$type錄音檔名稱',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed:
                          _recordingPath != null ? _submitRecording : null,
                      child: const Text('提交'),
                    ),
                    ElevatedButton(
                      onPressed:
                          _recordingPath != null ? _deleteRecording : null,
                      child: const Text('刪除'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  child: Text(_isRecording ? '停止錄音' : '開始錄音'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryPage() {
    return const Center(child: Text('歷史錄音頁面'));
  }
}
