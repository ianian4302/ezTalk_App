import 'package:flutter/material.dart';

class LecturePlayingPage extends StatefulWidget {
  const LecturePlayingPage({Key? key}) : super(key: key);
  @override
  State<LecturePlayingPage> createState() => _LecturePlayingPageState();
}

class _LecturePlayingPageState extends State<LecturePlayingPage>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('逐字稿撥放頁面'));
  }
}