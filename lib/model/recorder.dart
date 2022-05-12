import 'package:flutter_webrtc/flutter_webrtc.dart';

class Recorder {
  final String path;
  final MediaRecorder mediaRecorder;

  const Recorder(this.path, this.mediaRecorder);
}
