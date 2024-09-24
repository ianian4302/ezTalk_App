import 'package:flutter/material.dart';
import '../utilities/router.dart';
import '../utilities/design.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  void _navigateToPage(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定'), backgroundColor: Design.secondaryColor),
      body: ListView(
        children: [
          _buildCategory(context, '分類一', [
            _buildListItem(context, '選項 1-1', Routes.homePage),
            _buildListItem(context, '選項 1-2', Routes.homePage),
          ]),
          _buildCategory(context, '分類二', [
            _buildListItem(context, '選項 2-1', Routes.homePage),
            _buildListItem(context, '選項 2-2', Routes.homePage),
          ]),
          _buildCategory(context, '分類三', [
            _buildListItem(context, '選項 3-1', Routes.homePage),
            _buildListItem(context, '選項 3-2', Routes.homePage),
          ]),
          _buildCategory(context, '分類四', [
            _buildListItem(context, '選項 4-1', Routes.homePage),
            _buildListItem(context, '選項 4-2', Routes.homePage),
          ]),
          _buildCategory(context, '分類五', [
            _buildListItem(context, '選項 5-1', Routes.homePage),
            _buildListItem(context, '選項 5-2', Routes.homePage),
          ]),
        ],
      ),
    );
  }

  Widget _buildCategory(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(),
        ...items,
      ],
    );
  }

  Widget _buildListItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      onTap: () => _navigateToPage(context, route),
    );
  }
}
