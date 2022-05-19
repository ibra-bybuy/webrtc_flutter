import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc_demo/model/renderer.dart';
import 'package:flutter_webrtc_demo/model/user.dart';

import 'package:flutter_webrtc_demo/src/call_sample/signaling.dart';

class CallCubitState extends Equatable {
  final bool isCalling;
  final Session? session;
  final List<User> peers;
  final Renderer myRenderer;
  final List<Renderer> remoteRenderers;
  final bool myAsMain;
  const CallCubitState({
    this.isCalling = false,
    this.session,
    this.peers = const [],
    required this.myRenderer,
    this.remoteRenderers = const [],
    this.myAsMain = false,
  });

  CallCubitState copyWith({
    bool? isCalling,
    Session? session,
    List<User>? peers,
    Renderer? myRenderer,
    List<Renderer>? remoteRenderers,
    bool? myAsMain,
  }) {
    return CallCubitState(
      isCalling: isCalling ?? this.isCalling,
      session: session ?? this.session,
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
      peers: this.peers,
      myRenderer: this.myRenderer,
      remoteRenderers: this.remoteRenderers,
    );
  }

  @override
  String toString() {
    return 'CallCubitState(isCalling: $isCalling, session: $session, peers: $peers, myRenderer: $myRenderer, remoteRenderers: $remoteRenderers, myAsMain: $myAsMain)';
  }

  @override
  List<Object?> get props {
    return [
      isCalling,
      session,
      peers,
      myRenderer,
      remoteRenderers,
      myAsMain,
    ];
  }
}
