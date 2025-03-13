import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class RecordButton extends StatefulWidget {
  final Function(String) onRecordingComplete;

  const RecordButton({required this.onRecordingComplete, Key? key})
      : super(key: key);

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  final AudioRecorder audioRecorder = AudioRecorder();
  bool isRecording = false;

  void _toggleRecording() async {
    if (isRecording) {
      String? filePath = await audioRecorder.stop();
      if (filePath != null) {
        setState(() {
          isRecording = false;
        });
        widget.onRecordingComplete(filePath);
      }
    } else {
      if (await audioRecorder.hasPermission()) {
        final Directory appDocDirectory =
            await getApplicationDocumentsDirectory();
        final String filePath = path.join(
          appDocDirectory.path,
          'record_${DateTime.now().millisecondsSinceEpoch}.wav',
        );
        await audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.wav,
          ),
          path: filePath,
        );
        setState(() {
          isRecording = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ElevatedButton.icon(
        icon: Icon(isRecording ? Icons.stop : Icons.mic),
        label: Text(isRecording ? '停止錄音' : '開始錄音'),
        style: ElevatedButton.styleFrom(
          foregroundColor: isRecording ? Colors.red : Colors.blue,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: isRecording ? Colors.red : Colors.blue,
              width: 2,
            ),
          ),
        ),
        onPressed: _toggleRecording,
      ),
    );
  }
}
