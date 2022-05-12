import 'dart:typed_data';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_demo/core/functions/camera/camera_entities.dart';
import 'package:flutter_webrtc_demo/core/functions/gallery/gallery_saver.dart';
import 'package:flutter_webrtc_demo/core/functions/platform/current_platform.dart';
import 'package:flutter_webrtc_demo/model/recorder.dart';
import 'package:path_provider/path_provider.dart';

class Camera {
  final RTCVideoRenderer renderer;
  final List<RTCVideoRenderer> remoteRenders;
  final CameraEntities entities;
  const Camera(this.renderer, this.entities, {this.remoteRenders = const []});

  Camera.init(this.renderer, this.entities, {this.remoteRenders = const []}) {
    _init();
  }
  Future<void> _init() async {
    await renderer.initialize();
  }

  Future<void> dispose() async {
    clean();
    await renderer.dispose();
  }

  void disposeMyRender() {
    renderer.srcObject = null;
  }

  void disposeRemoteRenders() {
    if (remoteRenders.isNotEmpty) {
      for (final rm in remoteRenders) {
        rm.srcObject = null;
      }
    }
  }

  void disposeRenders() {
    disposeMyRender();
    disposeRemoteRenders();
  }

  void clean() {
    renderer.srcObject?.getTracks().forEach((track) => track.stop());
    entities.recorder = null;
    renderer.srcObject = null;
  }

  void setMediaRecorder(MediaStream mediaStream) {
    renderer.srcObject = mediaStream;
  }

  MediaStreamTrack? get getVideoTrack => renderer.srcObject
      ?.getVideoTracks()
      .firstWhere((track) => track.kind == 'video');

  Future<bool> switchCamera() async {
    bool cameraIsSwitched = false;
    final track = getVideoTrack;
    if (track != null) {
      cameraIsSwitched = await Helper.switchCamera(track);
      entities.switchCameraType();
    }

    return cameraIsSwitched;
  }

  Future<ByteBuffer?> captureFrame() async {
    final track = getVideoTrack;
    return await track?.captureFrame();
  }

  Future<void> startRecording() async {
    if (!isRecordingAvailable) {
      return;
    }
    final videoPath = await _videoStoragePath();
    if (videoPath == null) {
      return;
    }

    entities.recorder = Recorder(videoPath, MediaRecorder());

    await entities.recorder!.mediaRecorder
        .start(videoPath, videoTrack: getVideoTrack);
  }

  Future<void> stopRecording() async {
    await entities.recorder?.mediaRecorder.stop();

    GallerySaver(entities.recorder!.path).saveVideo();
    entities.recorder = null;
  }

  Future<String?> _videoStoragePath() async {
    final storagePath = await getExternalStorageDirectory();
    if (storagePath != null) {
      return storagePath.path +
          '/webrtc_sample/${DateTime.now().millisecondsSinceEpoch}.mp4';
    }
    return null;
  }

  Future<void> setFlash(bool flashOn) async {
    final track = getVideoTrack;

    if (track != null) {
      final has = await track.hasTorch();
      if (has) {
        await track.setTorch(flashOn);
        entities.isFlashOn = flashOn;
        print("FLASH ON");
        print(flashOn);
      }
    }
  }

  bool get isFaceMode => entities.cameraType == CameraType.front;
  bool get isBackMode => entities.cameraType == CameraType.back;
  bool get isFlashAvailable => entities.cameraType == CameraType.back;
  bool get isRecordingAvailable => CurrentPlatform.isAndroid;
  bool get isRecording => entities.recorder != null;
  bool get isFlashOn => entities.isFlashOn;
}
