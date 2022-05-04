import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_demo/core/functions/camera/camera_entities.dart';
import 'package:flutter_webrtc_demo/core/functions/phone_call/entities.dart';

class PhoneCall {
  final CameraType defaultCamera;
  final PhoneCallEntities entities;
  const PhoneCall(this.entities, {this.defaultCamera = CameraType.front});

  Future<MediaStream?> makeCall() async {
    try {
      final stream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);
      entities.isCalling = true;
      return stream;
    } catch (e) {
      return null;
    }
  }

  void endCall() {
    entities.isCalling = false;
  }

  String get defaultFacingMode {
    switch (defaultCamera) {
      case CameraType.back:
        return "environment";

      default:
        return "user";
    }
  }

  Map<String, dynamic> get mediaConstraints => {
        'audio': true,
        'video': {
          'mandatory': {
            'minWidth': '640',
            'minHeight': '480',
            'minFrameRate': '30',
          },
          'facingMode': defaultFacingMode,
          'optional': [],
        }
      };

  bool get isCalling => entities.isCalling;
}
