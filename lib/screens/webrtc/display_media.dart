import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_demo/core/functions/camera/camera.dart';
import 'package:flutter_webrtc_demo/core/functions/camera/camera_entities.dart';
import 'package:flutter_webrtc_demo/core/functions/phone_call/entities.dart';
import 'package:flutter_webrtc_demo/core/functions/phone_call/phone_call.dart';
import 'package:flutter_webrtc_demo/core/functions/platform/current_platform.dart';

/*
 * getUserMedia sample
 */
class GetUserMediaSample extends StatefulWidget {
  static String tag = 'get_usermedia_sample';

  const GetUserMediaSample({Key? key}) : super(key: key);

  @override
  _GetUserMediaSampleState createState() => _GetUserMediaSampleState();
}

class _GetUserMediaSampleState extends State<GetUserMediaSample> {
  late final Camera _cameraFunctions =
      Camera.init(RTCVideoRenderer(), CameraEntities());
  final PhoneCall _phoneCall = PhoneCall(PhoneCallEntities());

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
              child: const Text('OK'),
            )
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
                      onPressed: () {
                        _cameraFunctions.isRecording
                            ? _cameraFunctions.stopRecording()
                            : _cameraFunctions.startRecording();

                        setState(() {});
                      }),
                ],
              ]
            : null,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Center(
            child: Container(
              margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(color: Colors.black54),
              child: RTCVideoView(_cameraFunctions.renderer, mirror: true),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _phoneCall.isCalling ? _hangUp : _makeCall,
        tooltip: _phoneCall.isCalling ? 'Hangup' : 'Call',
        child: Icon(_phoneCall.isCalling ? Icons.call_end : Icons.phone),
      ),
    );
  }
}
