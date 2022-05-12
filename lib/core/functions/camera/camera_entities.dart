import 'package:flutter_webrtc_demo/model/recorder.dart';

enum CameraType { front, back }

class CameraEntities {
  CameraType cameraType;
  Recorder? recorder;
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
