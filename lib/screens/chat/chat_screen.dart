import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc_demo/core/cubits/chat/chat_cubit.dart';
import 'package:flutter_webrtc_demo/core/cubits/chat/chat_state.dart';
import 'package:flutter_webrtc_demo/screens/chat/components/comment_card.dart';

import 'components/textfield.dart';

class ChatScreen extends StatefulWidget {
  final ChatCubit chatCubit;
  final void Function(String)? onPressed;
  const ChatScreen({Key? key, required this.chatCubit, this.onPressed})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Чат")),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
                bloc: widget.chatCubit,
                builder: (context, state) {
                  return Container(
                    child: state.comments.isNotEmpty
                        ? ListView.builder(
                            itemCount: state.comments.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return CommentCard(
                                  comment: state.comments[index]);
                            },
                          )
                        : const SizedBox(),
                  );
                }),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: ChatTextField(
                    controller: _controller,
                  ),
                ),
                const SizedBox(width: 10.0),
                IconButton(
                  onPressed: () {
                    if (widget.onPressed != null) {
                      widget.onPressed!(_controller.text);
                    }
                    _controller.text = "";
                  },
                  icon: Icon(Icons.send),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
