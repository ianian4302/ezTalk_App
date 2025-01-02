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
  String _selectedVoice = Settings.currentVoice;
  double _pitch = Settings.currentPitch;
  double _rate = Settings.currentRate;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await Settings.loadSettings();
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUser = prefs.getString('currentUser') ?? '未登錄';
      _selectedVoice = Settings.currentVoice;
      _pitch = Settings.currentPitch;
      _rate = Settings.currentRate;
    });
  }

  Future<void> _saveSettings() async {
    await Settings.updateSettings(
      voice: _selectedVoice,
      pitch: _pitch,
      rate: _rate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('設定'), backgroundColor: Design.secondaryColor),
      body: ListView(
        children: [
          _buildCategory(context, '帳號信息', [
            ListTile(
              title: Text('當前用戶: $_currentUser'),
              trailing: SizedBox(
                width: 80,
                child: ElevatedButton(
                  child: const Text('登出'),
                  onPressed: () {
                    // 實現登出邏輯
                  },
                ),
              ),
            ),
          ]),
          _buildCategory(context, '語音設置', [
            ListTile(
              title: const Text('選擇語音'),
              trailing: SizedBox(
                width: 180,
                child: DropdownButton<String>(
                  value: _selectedVoice,
                  isExpanded: true,
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
                        child: Text(
                          voice,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: SizedBox(
                width: 150,
                child: Text('音調: ${_pitch.toStringAsFixed(2)}'),
              ),
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
              title: SizedBox(
                width: 150,
                child: Text('語速: ${_rate.toStringAsFixed(2)}'),
              ),
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

  Widget _buildCategory(
      BuildContext context, String title, List<Widget> items) {
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
