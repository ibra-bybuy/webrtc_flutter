import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:flutter_webrtc_demo/model/comment.dart';

class ChatState extends Equatable {
  final List<Comment> comments;
  const ChatState({
    required this.comments,
  });

  ChatState copyWith({
    List<Comment>? comments,
  }) {
    return ChatState(
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'comments': comments.map((x) => x.toMap()).toList(),
    };
  }

  factory ChatState.fromMap(Map<String, dynamic> map) {
    return ChatState(
      comments:
          List<Comment>.from(map['comments']?.map((x) => Comment.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatState.fromJson(String source) =>
      ChatState.fromMap(json.decode(source));

  @override
  String toString() => 'ChatState(comments: $comments)';

  @override
  List<Object> get props => [comments];
}
