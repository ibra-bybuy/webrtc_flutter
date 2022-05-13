import 'package:flutter/material.dart';

class CallDialog {
  final BuildContext context;
  final void Function(BuildContext, String) onCall;
  String _id = "";
  CallDialog(this.context, this.onCall);

  void call() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(hintText: "ID собеседника"),
              onChanged: (str) => _id = str,
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(primary: Colors.grey),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Закрыть"),
          ),
          TextButton(
            onPressed: () => onCall(context, _id),
            child: Text("Позвонить"),
          )
        ],
      ),
    );
  }
}
