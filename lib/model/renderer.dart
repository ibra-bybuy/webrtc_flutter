import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Renderer extends Equatable {
  final String id;
  final RTCVideoRenderer videoRenderer;
  Renderer({
    this.id = "",
    required this.videoRenderer,
  });

  Renderer copyWith({
    String? id,
    RTCVideoRenderer? videoRenderer,
  }) {
    return Renderer(
      id: id ?? this.id,
      videoRenderer: videoRenderer ?? this.videoRenderer,
    );
  }

  @override
  String toString() => 'Renderer(id: $id, videoRenderer: $videoRenderer)';

  @override
  List<Object> get props => [id, videoRenderer];
}
