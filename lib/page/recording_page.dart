import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utilities/design.dart';

class RecordingPage extends StatefulWidget {
  const RecordingPage({Key? key}) : super(key: key);
  @override
  State<RecordingPage> createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _isRecording = false;
  String? _recordingPath;
  final TextEditingController _nameController = TextEditingController();

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
              Tab(text: '整句串接'),
              Tab(text: '歷史語句'),
              Tab(text: '逐字稿撥放'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildRecordingPage(),
            const Center(child: Text('歷史語句頁面')),
            const Center(child: Text('逐字稿撥放頁面')),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordingPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: '錄音檔名稱',
              border: OutlineInputBorder(),
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
                      onPressed: _recordingPath != null ? _submitRecording : null,
                      child: const Text('提交'),
                    ),
                    ElevatedButton(
                      onPressed: _recordingPath != null ? _deleteRecording : null,
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
}
