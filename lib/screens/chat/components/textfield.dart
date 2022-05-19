import 'package:flutter/material.dart';

class ChatTextField extends StatelessWidget {
  final TextEditingController? controller;
  const ChatTextField({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Введите текст",
        border: InputBorder.none,
      ),
    );
  }
}
