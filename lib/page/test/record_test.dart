import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:eztalk/api/eztalk_api.dart';
import 'package:eztalk/utilities/recorder.dart'; // Import the new Recorder class

class RecordTestPage extends StatefulWidget {
  const RecordTestPage({Key? key}) : super(key: key);

  @override
  State<RecordTestPage> createState() => _RecordTestPageState();
}

class _RecordTestPageState extends State<RecordTestPage> {
  final Recorder recorder =
      Recorder(); // Create an instance of the new Recorder class
  final AudioPlayer audioPlayer = AudioPlayer();
  final EztalkApi api = EztalkApi();

  String? recordingPath;
  bool isRecording = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _recordingButton(),
      body: buildUI(),
    );
  }

  Widget buildUI() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (recordingPath != null)
            MaterialButton(
              onPressed: () async {
                setState(() {
                  isPlaying = !isPlaying;
                });
                if (isPlaying) {
                  await audioPlayer.setFilePath(recordingPath!);
                  await audioPlayer.play();
                } else {
                  await audioPlayer.stop();
                }
              },
              color: Theme.of(context).colorScheme.primary,
              child: Text(isPlaying ? 'Stop' : 'Play'),
            ),
          if (recordingPath == null) const Text('no recording found'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (recordingPath != null) {
                await api.uploadFile(recordingPath!, 'ianian4302');
              }
            },
            child: const Text('Upload Recording'),
          ),
        ],
      ),
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
