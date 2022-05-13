import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_demo/core/functions/gallery/gallery_saver.dart';
import 'package:flutter_webrtc_demo/core/functions/platform/current_platform.dart';
import 'package:flutter_webrtc_demo/model/recorder.dart';
import 'package:path_provider/path_provider.dart';

class VideoRecorderCubit extends Cubit<bool> {
  final RTCVideoRenderer renderer;
  Recorder? recorder;
  VideoRecorderCubit(this.renderer) : super(false);

  Future<void> startRecording() async {
    if (!isRecordingAvailable) {
      return;
    }
    final videoPath = await _videoStoragePath();
    if (videoPath == null) {
      return;
    }

    recorder = Recorder(videoPath, MediaRecorder());
    await recorder!.mediaRecorder
        .start(videoPath, videoTrack: getVideoTrack(renderer));

    emit(true);
  }

  Future<void> stopRecording() async {
    await recorder?.mediaRecorder.stop();
    if (recorder != null) {
      GallerySaver(recorder!.path).saveVideo();
      emit(false);
    }
  }

  Future<String?> _videoStoragePath() async {
    final storagePath = await getExternalStorageDirectory();
    if (storagePath != null) {
      return storagePath.path +
          '/webrtc_sample/${DateTime.now().millisecondsSinceEpoch}.mp4';
    }
    return null;
  }

  MediaStreamTrack? getVideoTrack(RTCVideoRenderer renderer) =>
      renderer.srcObject
          ?.getVideoTracks()
          .firstWhere((track) => track.kind == 'video');

  bool get isRecordingAvailable => CurrentPlatform.isAndroid;
  bool get isRecording => state;
}
