import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class Recorder extends StatefulWidget {
  final Function(String) onStop;

  const Recorder({Key? key, required this.onStop}) : super(key: key);

  @override
  State<Recorder> createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {
  final AudioRecorder audioRecorder = AudioRecorder();
  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        if (isRecording) {
          String? filepath = await audioRecorder.stop();
          if (filepath != null) {
            setState(() {
              isRecording = false;
            });
            widget.onStop(filepath);
            // print('Recorded at $filepath');
          }
        } else {
          if (await audioRecorder.hasPermission()) {
            final Directory appDoduleDirectory =
                await getApplicationDocumentsDirectory();
            final String filePath = path.join(
              appDoduleDirectory.path,
              'record_${DateTime.now().millisecondsSinceEpoch}.m4a',
            );
            await audioRecorder.start(const RecordConfig(), path: filePath);
            setState(() {
              isRecording = true;
            });
          }
        }
      },
      child: Icon(isRecording ? Icons.stop : Icons.mic),
    );
  }
}
