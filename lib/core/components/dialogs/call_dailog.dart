import 'package:flutter/material.dart';

class CallDialog {
  final BuildContext context;
  final void Function(BuildContext, String) onCall;
  String _id = "";
  final List<dynamic> peers;
  final String? myId;
  CallDialog(
    this.context,
    this.onCall, {
    this.peers = const [],
    this.myId,
  });

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
            if (peers.isNotEmpty) ...[
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                width: double.maxFinite,
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: peers.length,
                  itemBuilder: (context, index) {
                    final isMe = (peers[index]['id'] == myId);
                    if (isMe) return SizedBox();

                    return InkWell(
                      onTap: () => onCall(context, peers[index]['id']),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(peers[index]['name']),
                      ),
                    );
                  },
                ),
              ),
            ],
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
