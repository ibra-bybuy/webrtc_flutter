import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_demo/core/functions/gallery/gallery_saver.dart';

import '../image/image_writer.dart';

class CaptureFrame {
  final RTCVideoRenderer renderer;
  const CaptureFrame(this.renderer);

  Future<void> call(BuildContext context) async {
    final frame = await _capture();
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
                final file = await ImageWriter(
                  frame.asUint8List(),
                  name: "screenshot.png",
                )();
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

  Future<ByteBuffer?> _capture() async {
    final track = getVideoTrack(renderer);
    return await track?.captureFrame();
  }

  MediaStreamTrack? getVideoTrack(RTCVideoRenderer renderer) =>
      renderer.srcObject
          ?.getVideoTracks()
          .firstWhere((track) => track.kind == 'video');
}
