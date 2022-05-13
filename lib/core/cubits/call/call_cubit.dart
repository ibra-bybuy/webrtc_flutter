import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_demo/src/call_sample/signaling.dart';

import 'call_state.dart';

class CallCubit extends Cubit<CallCubitState> {
  CallCubit()
      : super(
          CallCubitState(
            myRenderer: RTCVideoRenderer(),
            remoteRenderers: [RTCVideoRenderer()],
          ),
        );

  void setMyAsMain(bool set) {
    emit(state.copyWith(myAsMain: set));
  }

  void updateIsCalling(bool isCalling) {
    emit(state.copyWith(isCalling: isCalling));
  }

  void emitNewSession(Session? session) {
    emit(state.copyWithSession(session));
  }

  void updateMyId(String myId) {
    emit(state.copyWith(myId: myId));
  }

  void updatePeers(List<dynamic> peers) {
    emit(state.copyWith(peers: peers));
  }

  void addRemoteRenderer(RTCVideoRenderer newRenderer) {
    final list = List<RTCVideoRenderer>.from(state.remoteRenderers)
      ..add(myRenderer);

    emit(state.copyWith(remoteRenderers: list));
  }

  void disposeMyRenderer() {
    myRenderer.srcObject = null;
  }

  void disposeRemoteRenderers() {
    final renderers = remoteRenderers;
    for (final rd in renderers) rd.srcObject = null;
  }

  RTCVideoRenderer get myRenderer => state.myRenderer;
  List<RTCVideoRenderer> get remoteRenderers => state.remoteRenderers;
  Session? get session => state.session;
  String? get myId => state.myId;
}
