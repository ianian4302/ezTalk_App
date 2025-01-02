import 'dart:io';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';

class RecordTestPage extends StatefulWidget {
  const RecordTestPage({Key? key}) : super(key: key);

  @override
  State<RecordTestPage> createState() => _RecordTestPageState();
}

class _RecordTestPageState extends State<RecordTestPage> {
  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();

  String? recordingPath;
  bool isRecording = false;
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _recordingButton(),
      body: buildUI(),
    );
  }

  Widget buildUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (recordingPath != null)
            MaterialButton(
              onPressed: () async {
                if (audioPlayer.playing) {
                  await audioPlayer.stop();
                  setState(() {
                    isPlaying = false;
                  });
                } else {
                  await audioPlayer.setFilePath(recordingPath!);
                  audioPlayer.play();
                  setState(() {
                    isPlaying = true;
                  });
                }
              },
              color: Theme.of(context).colorScheme.primary,
              child: Text(isPlaying ? 'Stop' : 'Play'),
            ),
          if (recordingPath == null) const Text('no recording found'),
        ],
      ),
    );
  }

  Widget _recordingButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (isRecording) {
          String? filepath = await audioRecorder.stop();
          if (filepath != null) {
            setState(() {
              isRecording = false;
              recordingPath = filepath;
            });
            print('Recorded at $filepath');
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
              recordingPath = null;
            });
          }
        }
      },
      child: Icon(isRecording ? Icons.stop : Icons.mic),
    );
  }
}
