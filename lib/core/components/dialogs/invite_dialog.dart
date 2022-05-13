import 'package:flutter/material.dart';

class ShowInviteDialog {
  final BuildContext context;
  final void Function()? onCancel;
  const ShowInviteDialog(this.context, {this.onCancel});

  Future<bool?> call() {
    return showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("Ожидание"),
          actions: [
            TextButton(
              child: Text("Отменить"),
              onPressed: onCancel,
            ),
          ],
        );
      },
    );
  }
}
