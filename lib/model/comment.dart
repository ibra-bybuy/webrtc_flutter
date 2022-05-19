import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc_demo/model/user.dart';
import 'package:collection/collection.dart';

class Comment extends Equatable {
  final DateTime time;
  final String message;
  final User user;
  const Comment({
    required this.time,
    required this.message,
    required this.user,
  });

  Comment copyWith({
    DateTime? time,
    String? message,
    User? user,
  }) {
    return Comment(
      time: time ?? this.time,
      message: message ?? this.message,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time.millisecondsSinceEpoch,
      'message': message,
      'user': user.toMap(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      message: map['message'] ?? '',
      user: User.fromMap(map['user']),
    );
  }

  factory Comment.fromWs(Map<String, dynamic> map, List<User> users) {
    return Comment(
      time: DateTime.fromMillisecondsSinceEpoch(map['date']),
      message: map['comment'] ?? '',
      user: users.firstWhereOrNull((element) => element.id == map['from']) ??
          User(name: "Неизвест."),
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source));

  @override
  String toString() => 'Comment(time: $time, message: $message, user: $user)';

  @override
  List<Object> get props => [time, message, user];
}
