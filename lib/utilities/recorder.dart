import 'dart:io';
import 'package:record/record.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class Recorder {
  final AudioRecorder audioRecorder = AudioRecorder();
  bool _isRecording = false;

  Future<String?> startRecording() async {
    if (await audioRecorder.hasPermission()) {
      final Directory appDocDirectory =
          await getApplicationDocumentsDirectory();
      final String filePath = path.join(
        appDocDirectory.path,
        'record_${DateTime.now().millisecondsSinceEpoch}.wav',
      );
      await audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav, // 指定编码器为 WAV
        ),
        path: filePath,
      );
      _isRecording = true;
      return filePath;
    }
    return null;
  }

  Future<String?> stopRecording() async {
    if (_isRecording) {
      String? filePath = await audioRecorder.stop();
      _isRecording = false;
      return filePath;
    }
    return null;
  }

  bool get isRecording => _isRecording;
}
