import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_demo/core/cubits/call/call_cubit.dart';
import 'package:flutter_webrtc_demo/src/call_sample/signaling.dart';

class SignalingProvider {
  final CallCubit callCubit;
  Signaling? _signaling;
  final String host;
  final Future<bool?> Function()? onRinging;
  final void Function()? onHangup;
  final void Function()? onInvite;
  final void Function()? onConnected;
  bool _waitAccept = false;
  SignalingProvider(
    this.callCubit,
    this.host, {
    this.onRinging,
    this.onHangup,
    this.onInvite,
    this.onConnected,
  });

  void init() {
    _signaling ??= Signaling(host)..connect();
    _onSignalStateChange();
    _onCallStateChange();
    _onPeersUpdate();
    _onLocalStreamUpdate();
    _onAddRemoteStream();
    _onRemoveRemoteStream();
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
      if (onHangup != null) {
        onHangup!();
      }
    }
    _disposeMyRender();
    _disposeRemoteRenderers();
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
      callCubit.updateMyId(event['self']);
      callCubit.updatePeers(event['peers']);
    });
  }

  void _onLocalStreamUpdate() {
    _signaling?.onLocalStream = ((stream) async {
      setMyStream(stream);
    });
  }

  Future<void> setMyStream(MediaStream stream) async {
    if (callCubit.myRenderer.textureId == null) {
      await callCubit.myRenderer.initialize();
    }
    callCubit.myRenderer.srcObject = stream;
  }

  void _onAddRemoteStream() {
    _signaling?.onAddRemoteStream = ((_, stream) async {
      if (callCubit.remoteRenderers.first.textureId == null) {
        await callCubit.remoteRenderers.first.initialize();
        callCubit.addRemoteRenderer(callCubit.remoteRenderers.first);
      }
      callCubit.remoteRenderers.first.srcObject = stream;
    });
  }

  void _onRemoveRemoteStream() {
    _signaling?.onRemoveRemoteStream = ((_, stream) {
      _disposeRemoteRenderers();
    });
  }

  void _disposeRemoteRenderers() {
    final renderers = callCubit.remoteRenderers;
    for (final rd in renderers) {
      rd.srcObject = null;
    }
  }

  void _disposeMyRender() {
    callCubit.myRenderer.srcObject = null;
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
    _disposeMyRender();
    _disposeRemoteRenderers();
    callCubit.updateIsCalling(false);

    if (callCubit.session != null) {
      _signaling?.bye(callCubit.session!.sid);
    }
  }

  Future<void> deactivate() async {
    await callCubit.myRenderer.dispose();
    for (final rd in callCubit.remoteRenderers) {
      await rd.dispose();
    }
    _signaling?.close();
  }

  Future<void> makeCall() async {
    try {
      final stream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);

      await setMyStream(stream);
      callCubit.updateIsCalling(true);
    } catch (e) {
      print(e);
      return null;
    }
  }

  void inviteById(String peerId, {bool useScreen = false}) async {
    if (_signaling != null && peerId != callCubit.myId) {
      _signaling?.invite(peerId, 'video', useScreen);
    }
  }

  Map<String, dynamic> get mediaConstraints => {
        'audio': true,
        'video': {'facingMode': "user", 'echoCancellation': true}
      };
}
