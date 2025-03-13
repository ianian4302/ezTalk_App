import 'package:flutter/material.dart';

class RecordingButton extends StatefulWidget {
  @override
  _RecordingButtonState createState() => _RecordingButtonState();
}

class _RecordingButtonState extends State<RecordingButton> {
  bool isRecording = false;

  void _toggleRecording() {
    setState(() {
      isRecording = !isRecording;
    });
    // Add your audio recording functionality here
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isRecording ? Icons.stop : Icons.mic),
      color: isRecording ? Colors.red : Colors.black,
      onPressed: _toggleRecording,
    );
  }
}
