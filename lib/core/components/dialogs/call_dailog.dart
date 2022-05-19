import 'package:flutter/material.dart';
import 'package:flutter_webrtc_demo/model/user.dart';

class CallDialog {
  final BuildContext context;
  final void Function(BuildContext, String, bool) onCall;
  //String _id = "";
  final List<User> peers;
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
            // TextField(
            //   decoration: InputDecoration(hintText: "ID собеседника"),
            //   onChanged: (str) => _id = str,
            // ),
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
                    final user = peers[index];

                    final isMe = user.id == myId;
                    if (isMe) return SizedBox();

                    return InkWell(
                      onTap: () => onCall(context, user.id, false),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(child: Text(user.name)),
                            const SizedBox(width: 30.0),
                            IconButton(
                                onPressed: () => onCall(context, user.id, true),
                                icon: Icon(Icons.screen_share)),
                          ],
                        ),
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
          // TextButton(
          //   onPressed: () => onCall(context, _id, false),
          //   child: Text("Позвонить"),
          // )
        ],
      ),
    );
  }
}
