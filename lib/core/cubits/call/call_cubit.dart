import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_demo/model/renderer.dart';
import 'package:flutter_webrtc_demo/src/call_sample/signaling.dart';

import 'call_state.dart';

class CallCubit extends Cubit<CallCubitState> {
  CallCubit()
      : super(
          CallCubitState(
            myRenderer: Renderer(videoRenderer: RTCVideoRenderer()),
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
    emit(state.copyWith(myRenderer: myRenderer.copyWith(id: myId)));
  }

  void updatePeers(List<dynamic> peers) {
    emit(state.copyWith(peers: peers));
  }

  void addRemoteRenderer(Renderer renderer) {
    final list = List<Renderer>.from(state.remoteRenderers)..add(renderer);

    emit(state.copyWith(remoteRenderers: list));
  }

  void cleanRemoteRenderers() {
    final list = List<Renderer>.from([]);

    emit(state.copyWith(remoteRenderers: list));
  }

  void disposeMyRenderer() {
    myVideoRenderer.srcObject = null;
  }

  void disposeRemoteRenderers() {
    final renderers = remoteVideoRenderers;
    for (final rd in renderers) rd.srcObject = null;
  }

  Renderer get myRenderer => state.myRenderer;
  RTCVideoRenderer get myVideoRenderer => state.myRenderer.videoRenderer;
  List<Renderer> get remoteRenderers => state.remoteRenderers;
  List<RTCVideoRenderer> get remoteVideoRenderers {
    return state.remoteRenderers.map((e) => e.videoRenderer).toList();
  }

  Session? get session => state.session;
  String get myId => state.myRenderer.id;
}
