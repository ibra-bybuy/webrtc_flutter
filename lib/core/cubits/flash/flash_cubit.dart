import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../camera_switcher/camera_switcher_cubit.dart';

class FlashCubit extends Cubit<bool> {
  final RTCVideoRenderer renderer;
  FlashCubit(this.renderer) : super(false);

  Future<void> setFlash(bool flashOn) async {
    final track = getVideoTrack(renderer);

    if (track != null && await track.hasTorch()) {
      await track.setTorch(flashOn);
      emit(flashOn);
    }
  }

  MediaStreamTrack? getVideoTrack(RTCVideoRenderer renderer) =>
      renderer.srcObject
          ?.getVideoTracks()
          .firstWhere((track) => track.kind == 'video');

  bool isFlashAvailable(CameraType cameraType) {
    print(cameraType);
    return cameraType == CameraType.back;
  }

  bool get isFlashOn => state;
}
