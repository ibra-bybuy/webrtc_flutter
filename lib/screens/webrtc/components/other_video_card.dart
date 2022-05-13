import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class OtherVideoCard extends StatelessWidget {
  final RTCVideoRenderer renderer;
  final bool mirror;
  const OtherVideoCard(this.renderer, {Key? key, this.mirror = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0.0,
      right: 0.0,
      top: 0.0,
      bottom: 0.0,
      child: Container(
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: RTCVideoView(renderer, mirror: mirror),
        decoration: BoxDecoration(color: Colors.black54),
      ),
    );
  }
}
