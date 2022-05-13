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
  const CallCubitState({
    this.isCalling = false,
    this.session,
    this.myId,
    this.peers = const [],
    required this.myRenderer,
    this.remoteRenderers = const [],
  });

  CallCubitState copyWith({
    bool? isCalling,
    Session? session,
    String? myId,
    List<dynamic>? peers,
    RTCVideoRenderer? myRenderer,
    List<RTCVideoRenderer>? remoteRenderers,
  }) {
    return CallCubitState(
      isCalling: isCalling ?? this.isCalling,
      session: session ?? this.session,
      myId: myId ?? this.myId,
      peers: peers ?? this.peers,
      myRenderer: myRenderer ?? this.myRenderer,
      remoteRenderers: remoteRenderers ?? this.remoteRenderers,
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
    return 'CallCubitState(isCalling: $isCalling, session: $session, myId: $myId, peers: $peers, myRenderer: $myRenderer, remoteRenderers: $remoteRenderers)';
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
    ];
  }
}
