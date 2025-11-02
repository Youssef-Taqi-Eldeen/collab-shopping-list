import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({super.key, required this.onPressed, required this.text, required this.textColor});

  final void Function() onPressed;
  final String text;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
      color: textColor,
    ),));
  }
}
