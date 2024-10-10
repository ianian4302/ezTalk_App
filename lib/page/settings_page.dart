import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eztalk/utilities/design.dart';
import 'package:eztalk/utilities/settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _currentUser = '';
  String _selectedVoice = Settings.voices.keys.first;
  double _pitch = Settings.pitch;
  double _rate = Settings.rate;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUser = prefs.getString('currentUser') ?? '未登錄';
      _selectedVoice = prefs.getString('selectedVoice') ?? Settings.voices.keys.first;
      _pitch = prefs.getDouble('pitch') ?? Settings.pitch;
      _rate = prefs.getDouble('rate') ?? Settings.rate;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedVoice', _selectedVoice);
    await prefs.setDouble('pitch', _pitch);
    await prefs.setDouble('rate', _rate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定'), backgroundColor: Design.secondaryColor),
      body: ListView(
        children: [
          _buildCategory(context, '帳號信息', [
            ListTile(
              title: Text('當前用戶: $_currentUser'),
              trailing: ElevatedButton(
                child: const Text('登出'),
                onPressed: () {
                  // 實現登出邏輯
                },
              ),
            ),
          ]),
          _buildCategory(context, '語音設置', [
            ListTile(
              title: const Text('選擇語音'),
              trailing: DropdownButton<String>(
                value: _selectedVoice,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedVoice = newValue;
                    });
                    _saveSettings();
                  }
                },
                items: [
                  for (var voice in Settings.voices.keys)
                    DropdownMenuItem<String>(
                      value: voice,
                      child: Text(voice),
                    ),
                ],
              ),
            ),
            ListTile(
              title: Text('音調: ${_pitch.toStringAsFixed(2)}'),
              subtitle: Slider(
                value: _pitch,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                onChanged: (double value) {
                  setState(() {
                    _pitch = value;
                  });
                },
                onChangeEnd: (double value) {
                  _saveSettings();
                },
              ),
            ),
            ListTile(
              title: Text('語速: ${_rate.toStringAsFixed(2)}'),
              subtitle: Slider(
                value: _rate,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                onChanged: (double value) {
                  setState(() {
                    _rate = value;
                  });
                },
                onChangeEnd: (double value) {
                  _saveSettings();
                },
              ),
            ),
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
}
