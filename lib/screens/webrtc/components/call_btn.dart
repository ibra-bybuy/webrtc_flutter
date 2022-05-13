import 'package:flutter/material.dart';

class CallBtn extends StatelessWidget {
  final bool isCalling;
  final void Function()? onPressed;
  const CallBtn({Key? key, required this.isCalling, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: isCalling ? Colors.red : null,
      tooltip: isCalling ? 'Сбросить' : 'Позвонить',
      child: Icon(
        isCalling ? Icons.call_end : Icons.phone,
      ),
    );
  }
}
