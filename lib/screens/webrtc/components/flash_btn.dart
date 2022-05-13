import 'package:flutter/material.dart';

class FlashBtn extends StatelessWidget {
  final bool isFlashOn;
  final void Function()? onPressed;
  const FlashBtn({Key? key, this.isFlashOn = false, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isFlashOn ? Icons.flash_off : Icons.flash_on),
      onPressed: onPressed,
    );
  }
}
