import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class OtherVideoCard extends StatelessWidget {
  final RTCVideoRenderer renderer;
  final bool mirror;
  final List<Widget> stackChildren;
  const OtherVideoCard(
    this.renderer, {
    Key? key,
    this.mirror = false,
    this.stackChildren = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0.0,
      right: 0.0,
      top: 0.0,
      bottom: 0.0,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: Stack(
          children: [
            RTCVideoView(
              renderer,
              mirror: mirror,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),
          ]..addAll(stackChildren),
        ),
        decoration: BoxDecoration(color: Colors.black54),
      ),
    );
  }
}
