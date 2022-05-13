import 'package:flutter/material.dart';

class SwitchCameraBtn extends StatelessWidget {
  final void Function()? onPressed;
  const SwitchCameraBtn({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.switch_video),
      onPressed: onPressed,
    );
  }
}
