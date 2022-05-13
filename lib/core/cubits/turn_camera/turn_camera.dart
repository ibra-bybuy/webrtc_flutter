import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class TurnCameraCubit extends Cubit<bool> {
  final RTCVideoRenderer renderer;
  TurnCameraCubit(this.renderer, bool initialState) : super(initialState);

  void turnOff() {
    _set(false);
  }

  void turnOn() {
    _set(true);
  }

  void _set(bool enable) {
    if (getVideoTrack != null) {
      getVideoTrack!.enabled = enable;
      emit(enable);
    }
  }

  MediaStreamTrack? get getVideoTrack => renderer.srcObject
      ?.getVideoTracks()
      .firstWhere((track) => track.kind == 'video');
}
