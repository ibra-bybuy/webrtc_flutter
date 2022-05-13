import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'package:flutter_webrtc_demo/src/call_sample/signaling.dart';

class CallCubitState extends Equatable {
  final bool isCalling;
  final Session? session;
  final String? myId;
  final List<dynamic> peers;
  final RTCVideoRenderer myRenderer;
  final List<RTCVideoRenderer> remoteRenderers;
  final bool myAsMain;
  const CallCubitState({
    this.isCalling = false,
    this.session,
    this.myId,
    this.peers = const [],
    required this.myRenderer,
    this.remoteRenderers = const [],
    this.myAsMain = false,
  });

  CallCubitState copyWith({
    bool? isCalling,
    Session? session,
    String? myId,
    List<dynamic>? peers,
    RTCVideoRenderer? myRenderer,
    List<RTCVideoRenderer>? remoteRenderers,
    bool? myAsMain,
  }) {
    return CallCubitState(
      isCalling: isCalling ?? this.isCalling,
      session: session ?? this.session,
      myId: myId ?? this.myId,
      peers: peers ?? this.peers,
      myRenderer: myRenderer ?? this.myRenderer,
      remoteRenderers: remoteRenderers ?? this.remoteRenderers,
      myAsMain: myAsMain ?? this.myAsMain,
    );
  }

  CallCubitState copyWithSession(
    Session? session,
  ) {
    return CallCubitState(
      isCalling: this.isCalling,
      session: session,
      myId: myId ?? this.myId,
      peers: this.peers,
      myRenderer: this.myRenderer,
      remoteRenderers: this.remoteRenderers,
    );
  }

  @override
  String toString() {
    return 'CallCubitState(isCalling: $isCalling, session: $session, myId: $myId, peers: $peers, myRenderer: $myRenderer, remoteRenderers: $remoteRenderers, myAsMain: $myAsMain)';
  }

  @override
  List<Object?> get props {
    return [
      isCalling,
      session,
      myId,
      peers,
      myRenderer,
      remoteRenderers,
      myAsMain,
    ];
  }
}
