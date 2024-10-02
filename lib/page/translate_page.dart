import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utilities/design.dart';
import 'translate/series_connecting_page.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({Key? key}) : super(key: key);
  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 0; // 預設選中第一個頁面
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('翻譯'),
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
            SeriesConnectingPage(),
            const Center(child: Text('歷史語句頁面')),
            const Center(child: Text('逐字稿撥放頁面')),
          ],
        ),
      ),
    );
  }
}
