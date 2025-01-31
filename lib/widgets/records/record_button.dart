import 'package:flutter/material.dart';

class RecordButton extends StatefulWidget {
  final bool isRecording;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;

  const RecordButton({
    Key? key,
    required this.isRecording,
    required this.onStartRecording,
    required this.onStopRecording,
  }) : super(key: key);

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ElevatedButton.icon(
        icon: Icon(widget.isRecording ? Icons.stop : Icons.mic),
        label: Text(widget.isRecording ? '停止錄音' : '開始錄音'),
        style: ElevatedButton.styleFrom(
          foregroundColor: widget.isRecording ? Colors.red : Colors.blue,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: widget.isRecording ? Colors.red : Colors.blue,
              width: 2,
            ),
          ),
        ),
        onPressed: () {
          if (widget.isRecording) {
            widget.onStopRecording();
          } else {
            widget.onStartRecording();
          }
        },
      ),
    );
  }
}
