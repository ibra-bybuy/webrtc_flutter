import 'package:flutter/material.dart';

class ScreenshotBtn extends StatelessWidget {
  final void Function()? onPressed;
  const ScreenshotBtn({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.camera),
      onPressed: onPressed,
    );
  }
}
