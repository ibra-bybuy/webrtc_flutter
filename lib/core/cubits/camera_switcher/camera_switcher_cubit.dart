import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

enum CameraType { front, back }

class CameraSwitchCubit extends Cubit<CameraType> {
  final RTCVideoRenderer renderer;
  CameraSwitchCubit(this.renderer) : super(CameraType.front);

  Future<void> switchCam() async {
    final track = getVideoTrack(renderer);
    if (track != null) {
      await Helper.switchCamera(track);

      final cameraType =
          state == CameraType.front ? CameraType.back : CameraType.front;
      setCameraType(cameraType);
    }
  }

  void setCameraType(CameraType cType) {
    emit(cType);
  }

  MediaStreamTrack? getVideoTrack(RTCVideoRenderer renderer) =>
      renderer.srcObject
          ?.getVideoTracks()
          .firstWhere((track) => track.kind == 'video');

  bool get isFaceMode => state == CameraType.front;
  bool get isBackMode => state == CameraType.back;
}
