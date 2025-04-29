import 'package:flutter/material.dart';
import 'package:eztalk/utilities/recorder.dart';
import 'package:eztalk/utilities/design.dart';

class DataCollectionPage extends StatefulWidget {
  const DataCollectionPage({Key? key}) : super(key: key);
  @override
  State<DataCollectionPage> createState() => _DataCollectionPageState();
}

class _DataCollectionPageState extends State<DataCollectionPage>
    with SingleTickerProviderStateMixin {
  bool isRecording = false;
  final Recorder recorder = Recorder();
  String? recordingPath;
  final TextEditingController _nameController = TextEditingController();
  late TabController _tabController;
  TextEditingController selectedWordController =
      TextEditingController(); // 用於存儲選中的單詞
  List<String> words = [
    "tmp",
    "一個人的確是很重要",
    "一場比賽中第一名",
    "一次我的人生",
    "七月份資料",
    "下雨的時候要穿雨衣",
    "不到一個人生就可以",
    "不如意事",
    "不小心用打火機造成意外",
    "不少朋友們",
    "不需要太多的時間",
    "今天的天氣真是太好了",
    "學習新技能是一件很有趣的事情",
    "下班後我們一起去吃飯吧",
    "這本書的內容非常有啟發性",
    "旅行能讓人放鬆心情，增廣見聞",
    "成功需要不斷的努力和堅持",
    "音樂是生活中不可或缺的一部分",
    "每一天都是一個新的開始",
    "團隊合作是完成大項目的關鍵",
    "保持健康是最重要的事情之一",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 0; // 預設選中第一個頁面
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
        body: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: [
                _buildSingleRecordingPage('單句'),
                _buildRecordingPage('整句'),
                _buildHistoryPage(),
              ],
            ),
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: _recordingButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleRecordingPage(String type) {
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
        ],
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
        ],
      ),
    );
  }

  Widget _buildHistoryPage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: selectedWordController,
            decoration: const InputDecoration(
              labelText: '選擇語句',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(4.0),
            itemCount: words.length,
            itemBuilder: (context, index) {
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedWordController.text = words[index];
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                child: Text(words[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 80), // 預留空間放錄音按鈕
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
              //  TODO: 上傳錄音檔案的邏輯
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
