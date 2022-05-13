import 'package:flutter/material.dart';

class ShowAcceptDialog {
  final BuildContext context;
  const ShowAcceptDialog(this.context);

  Future<bool?> call() async {
    return showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("Принять звонок?"),
          actions: [
            TextButton(
              child: Text("Отклонить"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text("Принять"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
