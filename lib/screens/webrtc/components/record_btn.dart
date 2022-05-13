import 'package:flutter/material.dart';

class RecordBtn extends StatelessWidget {
  final bool isRecording;
  final void Function()? onPressed;
  const RecordBtn({Key? key, this.isRecording = false, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isRecording ? Icons.stop : Icons.fiber_manual_record),
      onPressed: onPressed,
    );
  }
}
