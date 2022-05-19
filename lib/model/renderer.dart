import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'package:flutter_webrtc_demo/model/user.dart';

class Renderer extends Equatable {
  final User user;
  final RTCVideoRenderer videoRenderer;
  Renderer({
    this.user = const User(),
    required this.videoRenderer,
  });

  Renderer copyWith({
    User? user,
    RTCVideoRenderer? videoRenderer,
  }) {
    return Renderer(
      user: user ?? this.user,
      videoRenderer: videoRenderer ?? this.videoRenderer,
    );
  }

  @override
  String toString() => 'Renderer(user: $user, videoRenderer: $videoRenderer)';

  @override
  List<Object> get props => [user, videoRenderer];
}
