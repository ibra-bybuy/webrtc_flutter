import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_demo/core/cubits/call/call_cubit.dart';
import 'package:flutter_webrtc_demo/model/comment.dart';
import 'package:flutter_webrtc_demo/model/renderer.dart';
import 'package:flutter_webrtc_demo/model/user.dart';
import 'package:flutter_webrtc_demo/src/call_sample/signaling.dart';
import 'package:collection/collection.dart';

class SignalingProvider {
  final CallCubit callCubit;
  Signaling? _signaling;
  final String host;
  final Future<bool?> Function()? onRinging;
  final void Function()? onHangup;
  final void Function()? onInvite;
  final void Function()? onConnected;
  final void Function()? onMicOff;
  final void Function(dynamic)? onComment;
  bool _waitAccept = false;
  SignalingProvider(
    this.callCubit,
    this.host, {
    this.onRinging,
    this.onHangup,
    this.onInvite,
    this.onConnected,
    this.onMicOff,
    this.onComment,
  });

  void init({String name = ""}) {
    _signaling ??= Signaling(host)..connect(name: name);
    _onSignalStateChange();
    _onCallStateChange();
    _onPeersUpdate();
    _onLocalStreamUpdate();
    _onAddRemoteStream();
    _onRemoveRemoteStream();
    _onComment();
  }

  void _onSignalStateChange() {
    _signaling?.onSignalingStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.ConnectionClosed:
        case SignalingState.ConnectionError:
        case SignalingState.ConnectionOpen:
          break;
      }
    };
  }

  void _onCallStateChange() {
    _signaling?.onCallStateChange = (Session session, CallState state) async {
      switch (state) {
        case CallState.CallStateNew:
          callCubit.emitNewSession(session);
          break;
        case CallState.CallStateRinging:
          _onRinging();
          break;
        case CallState.CallStateBye:
          _onHangup();
          break;
        case CallState.CallStateInvite:
          _onInvite();
          break;

        case CallState.CallStateConnected:
          _onConnected();
          break;

        case CallState.TurnMicOff:
          if (onMicOff != null) {
            onMicOff!();
          }

          break;

        case CallState.CallStateRinging:
      }
    };
  }

  Future<void> _onRinging() async {
    bool? accepted = true;
    if (onRinging != null) {
      accepted = await onRinging!();
    }
    if (accepted!) {
      accept();
      callCubit.updateIsCalling(true);
    } else {
      reject();
    }
  }

  void _onHangup() {
    if (_waitAccept) {
      _waitAccept = false;
    }
    if (onHangup != null) {
      onHangup!();
    }
    _nullMyRender();
    _nullRemoteRenderers();
    _cleanCubits();
  }

  void _cleanCubits() {
    callCubit.cleanRemoteRenderers();
    callCubit.emitNewSession(null);
    callCubit.updateIsCalling(false);
  }

  void _onInvite() {
    _waitAccept = true;
    if (onInvite != null) {
      onInvite!();
    }
  }

  void _onConnected() {
    if (_waitAccept) {
      _waitAccept = false;
      if (onConnected != null) {
        onConnected!();
      }
    }
    callCubit.updateIsCalling(true);
  }

  void _onPeersUpdate() {
    _signaling?.onPeersUpdate = ((event) {
      final users =
          (event['peers'] as List).map((e) => User.fromMap(e)).toList();

      final getMe =
          users.firstWhereOrNull((element) => element.id == event['self']);

      if (getMe != null) {
        callCubit.updateMe(getMe);
      }

      callCubit.updatePeers(users);
    });
  }

  void _onLocalStreamUpdate() {
    _signaling?.onLocalStream = ((stream) async {
      setMyStream(stream);
    });
  }

  Future<void> setMyStream(MediaStream stream) async {
    if (callCubit.myVideoRenderer.textureId == null) {
      await callCubit.myVideoRenderer.initialize();
    }
    callCubit.myVideoRenderer.srcObject = stream;
  }

  void _onAddRemoteStream() {
    _signaling?.onAddRemoteStream = ((sess, stream) async {
      final renderer = Renderer(
        videoRenderer: RTCVideoRenderer(),
        user: User(id: sess.pid),
      );

      await renderer.videoRenderer.initialize();
      renderer.videoRenderer.srcObject = stream;
      callCubit.addRemoteRenderer(renderer);
    });
  }

  void _onRemoveRemoteStream() {
    _signaling?.onRemoveRemoteStream = ((_, stream) {
      _nullRemoteRenderers();
    });
  }

  void _nullRemoteRenderers() {
    final renderers = callCubit.remoteVideoRenderers;
    for (final rd in renderers) {
      rd.srcObject = null;
    }
  }

  void _nullMyRender() {
    callCubit.myVideoRenderer.srcObject = null;
  }

  Future<void> _disposeMyRender() async {
    if (callCubit.myVideoRenderer.textureId != null) {
      await callCubit.myVideoRenderer.dispose();
    }
  }

  Future<void> _disposeRemoteRenders() async {
    for (final rd in callCubit.remoteVideoRenderers) {
      if (rd.textureId != null) {
        await rd.dispose();
      }
    }
  }

  void accept() {
    if (callCubit.session != null) {
      _signaling?.accept(callCubit.session!.sid);
    }
  }

  void reject() {
    if (callCubit.session != null) {
      _signaling?.reject(callCubit.session!.sid);
    }
  }

  void hangUp() {
    _nullMyRender();
    _nullRemoteRenderers();

    if (callCubit.session != null) {
      _signaling?.bye(callCubit.session!.sid);
    }
    _cleanCubits();
  }

  Future<void> deactivate() async {
    await _disposeMyRender();
    await _disposeRemoteRenders();
    _signaling?.close();
  }

  Future<void> makeCall() async {
    try {
      final stream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);

      await setMyStream(stream);
      callCubit.updateIsCalling(true);
    } catch (e) {
      return null;
    }
  }

  void inviteById(String peerId, {bool useScreen = false}) async {
    if (_signaling != null && peerId != callCubit.user.id) {
      _signaling?.invite(peerId, 'video', useScreen);
    }
  }

  void turnMicOff(String peerId) async {
    _signaling?.turnMicOf(peerId, callCubit.session?.sid ?? "");
  }

  void sendComment(Comment comment) async {
    _signaling?.sendComment(comment.message, callCubit.session?.sid ?? "");
  }

  void _onComment() {
    _signaling?.onComment = (data) {
      if (onComment != null) {
        onComment!(data);
      }
    };
  }

  Map<String, dynamic> get mediaConstraints => {
        'audio': true,
        'video': {'facingMode': "user", 'echoCancellation': true}
      };
}
