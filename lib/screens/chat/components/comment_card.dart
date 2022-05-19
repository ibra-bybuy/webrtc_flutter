import 'package:flutter/material.dart';
import 'package:flutter_webrtc_demo/core/functions/time/datetime_functions.dart';
import 'package:flutter_webrtc_demo/model/comment.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  const CommentCard({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(comment.user.name),
      subtitle: Text(comment.message),
      trailing: Text(DateFunctions(passedDate: comment.time).displayDate()),
    );
  }
}
