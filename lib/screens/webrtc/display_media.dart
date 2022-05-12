import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_demo/core/functions/camera/camera.dart';
import 'package:flutter_webrtc_demo/core/functions/camera/camera_entities.dart';
import 'package:flutter_webrtc_demo/core/functions/gallery/gallery_saver.dart';
import 'package:flutter_webrtc_demo/core/functions/image/image_writer.dart';
import 'package:flutter_webrtc_demo/core/functions/phone_call/entities.dart';
import 'package:flutter_webrtc_demo/core/functions/phone_call/phone_call.dart';
import 'package:flutter_webrtc_demo/core/functions/platform/current_platform.dart';
import 'package:flutter_webrtc_demo/src/call_sample/signaling.dart';

class GetUserMediaSample extends StatefulWidget {
  final String host;
  const GetUserMediaSample({Key? key, required this.host}) : super(key: key);

  @override
  _GetUserMediaSampleState createState() => _GetUserMediaSampleState();
}

class _GetUserMediaSampleState extends State<GetUserMediaSample> {
  late final Camera _cameraFunctions = Camera.init(
    RTCVideoRenderer(),
    CameraEntities(),
    remoteRenders: [
      RTCVideoRenderer(),
    ],
  );
  final PhoneCall _phoneCall = PhoneCall(PhoneCallEntities());

  Signaling? _signaling;
  Session? _session;
  bool _waitAccept = false;
  String? _selfId;
  List<dynamic> _peers = [];

  @override
  void initState() {
    super.initState();
    _connect();
  }

  void _connect() {
    _signaling ??= Signaling(widget.host)..connect();
    _signaling?.onSignalingStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.ConnectionClosed:
        case SignalingState.ConnectionError:
        case SignalingState.ConnectionOpen:
          break;
      }
    };

    _signaling?.onCallStateChange = (Session session, CallState state) async {
      switch (state) {
        case CallState.CallStateNew:
          setState(() {
            _session = session;
          });
          break;
        case CallState.CallStateRinging:
          bool? accept = await _showAcceptDialog();
          if (accept!) {
            _accept();
            setState(() {
              _phoneCall.entities.isCalling = true;
            });
          } else {
            _reject();
          }
          break;
        case CallState.CallStateBye:
          if (_waitAccept) {
            print('peer reject');
            _waitAccept = false;
            Navigator.of(context).pop(false);
          }
          setState(() {
            _cameraFunctions.disposeRenders();
            _phoneCall.entities.isCalling = false;
            _session = null;
          });
          break;
        case CallState.CallStateInvite:
          _waitAccept = true;
          _showInvateDialog();
          break;
        case CallState.CallStateConnected:
          if (_waitAccept) {
            _waitAccept = false;
            Navigator.of(context).pop(false);
          }
          setState(() {
            _phoneCall.entities.isCalling = true;
          });

          break;
        case CallState.CallStateRinging:
      }
    };

    _signaling?.onPeersUpdate = ((event) {
      setState(() {
        _selfId = event['self'];
        _peers = event['peers'];
      });
    });

    _signaling?.onLocalStream = ((stream) {
      _cameraFunctions.renderer.srcObject = stream;
    });

    _signaling?.onAddRemoteStream = ((_, stream) {
      if (_cameraFunctions.remoteRenders.isNotEmpty) {
        _cameraFunctions.remoteRenders.first.srcObject = stream;
      }
    });

    _signaling?.onRemoveRemoteStream = ((_, stream) {
      _cameraFunctions.disposeRemoteRenders();
    });
  }

  _accept() {
    if (_session != null) {
      _signaling?.accept(_session!.sid);
    }
  }

  _reject() {
    if (_session != null) {
      _signaling?.reject(_session!.sid);
    }
  }

  Future<bool?> _showAcceptDialog() {
    return showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("title"),
          content: Text("accept?"),
          actions: [
            TextButton(
              child: Text("reject"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text("accept"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showInvateDialog() {
    return showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("title"),
          content: Text("waiting"),
          actions: [
            TextButton(
              child: Text("cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
                _hangUp();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Future<void> deactivate() async {
    _hangUp();
    await _cameraFunctions.dispose();

    super.deactivate();
  }

  void _makeCall() async {
    final stream = await _phoneCall.makeCall();

    if (stream != null) {
      _cameraFunctions.setMediaRecorder(stream);
      if (!mounted) return;

      setState(() {});
    }
  }

  void _hangUp() {
    _phoneCall.endCall();
    _cameraFunctions.clean();

    setState(() {});
  }

  void _captureFrame() async {
    final frame = await _cameraFunctions.captureFrame();
    if (frame != null) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Image.memory(frame.asUint8List(), height: 720, width: 1280),
          actions: [
            TextButton(
              onPressed: Navigator.of(context, rootNavigator: true).pop,
              style: TextButton.styleFrom(primary: Colors.grey),
              child: const Text('Закрыть'),
            ),
            TextButton(
              onPressed: () async {
                final file = await ImageWriter(frame.asUint8List(),
                    name: "screenshot.png")();
                await GallerySaver(file.path).saveImage();
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Звонок'),
        actions: _phoneCall.isCalling
            ? [
                if (_cameraFunctions.isFlashAvailable) ...[
                  IconButton(
                      icon: Icon(_cameraFunctions.isFlashOn
                          ? Icons.flash_off
                          : Icons.flash_on),
                      onPressed: () async {
                        await _cameraFunctions
                            .setFlash(!_cameraFunctions.isFlashOn);
                        setState(() {});
                      }),
                ],
                if (CurrentPlatform.isMobile) ...[
                  IconButton(
                    icon: const Icon(Icons.switch_video),
                    onPressed: () async {
                      await _cameraFunctions.switchCamera();

                      if (_cameraFunctions.isFlashOn) {
                        await _cameraFunctions.setFlash(false);
                      }

                      setState(() {});
                    },
                  ),
                ],
                IconButton(
                  icon: const Icon(Icons.camera),
                  onPressed: _captureFrame,
                ),
                if (_cameraFunctions.isRecordingAvailable) ...[
                  IconButton(
                      icon: Icon(_cameraFunctions.isRecording
                          ? Icons.stop
                          : Icons.fiber_manual_record),
                      onPressed: () async {
                        _cameraFunctions.isRecording
                            ? await _cameraFunctions.stopRecording()
                            : await _cameraFunctions.startRecording();

                        setState(() {});
                      }),
                ],
              ]
            : null,
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return Container(
          child: Stack(
            children: List<Widget>.generate(
              _cameraFunctions.remoteRenders.length,
              (index) => Positioned(
                left: 0.0,
                right: 0.0,
                top: 0.0,
                bottom: 0.0,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: RTCVideoView(_cameraFunctions.remoteRenders[index]),
                  decoration: BoxDecoration(color: Colors.black54),
                ),
              ),
            )..add(
                Positioned(
                  right: 20.0,
                  top: 20.0,
                  child: Container(
                    width: 100,
                    height: 120,
                    child: RTCVideoView(
                      _cameraFunctions.renderer,
                      mirror: _cameraFunctions.isFaceMode,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    ),
                  ),
                ),
              ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _phoneCall.isCalling
            ? _hangUp
            : () {
                _makeCall();
              },
        tooltip: _phoneCall.isCalling ? 'Hangup' : 'Call',
        child: Icon(_phoneCall.isCalling ? Icons.call_end : Icons.phone),
      ),
    );
  }
}
