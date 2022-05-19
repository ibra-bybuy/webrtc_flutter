import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc_demo/model/comment.dart';

import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatState(comments: []));

  void addComments(List<Comment> newComments) {
    emit(state.copyWith(comments: List.from(comments)..addAll(newComments)));
  }

  List<Comment> get comments => state.comments;
}
