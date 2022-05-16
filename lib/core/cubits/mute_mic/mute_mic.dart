import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class MuteMicCubit extends Cubit<bool> {
  final RTCVideoRenderer renderer;
  MuteMicCubit(this.renderer, bool initialState) : super(initialState);

  void muteMic({bool? force}) {
    if (getTrack != null) {
      bool switched = force ?? !getTrack!.enabled;
      getTrack!.enabled = switched;
      emit(switched);
    }
  }

  MediaStreamTrack? get getTrack => renderer.srcObject?.getAudioTracks()[0];
}
