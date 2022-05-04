import 'package:flutter_webrtc/flutter_webrtc.dart';

enum CameraType { front, back }

class CameraEntities {
  CameraType cameraType;
  MediaRecorder? mediaRecorder;
  bool isFlashOn;
  CameraEntities({
    this.cameraType = CameraType.front,
    this.isFlashOn = false,
  });

  void switchCameraType() {
    cameraType =
        cameraType == CameraType.front ? CameraType.back : CameraType.front;
  }
}
