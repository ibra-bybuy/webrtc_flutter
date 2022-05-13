import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class MyVideoCard extends StatelessWidget {
  final RTCVideoRenderer renderer;
  final bool mirror;
  final void Function()? onTap;
  const MyVideoCard(this.renderer, {Key? key, this.mirror = false, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20.0,
      top: 20.0,
      child: Container(
        width: 100,
        height: 120,
        child: GestureDetector(
          onTap: onTap,
          child: RTCVideoView(
            renderer,
            mirror: mirror,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),
        ),
      ),
    );
  }
}
