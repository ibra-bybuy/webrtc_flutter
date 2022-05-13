import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class MuteMicCubit extends Cubit<bool> {
  final RTCVideoRenderer renderer;
  MuteMicCubit(this.renderer, bool initialState) : super(initialState);

  void muteMic() {
    if (getTrack != null) {
      bool enabled = getTrack!.enabled;
      getTrack!.enabled = !enabled;
      emit(!enabled);
    }
  }

  MediaStreamTrack? get getTrack => renderer.srcObject?.getAudioTracks()[0];
}
