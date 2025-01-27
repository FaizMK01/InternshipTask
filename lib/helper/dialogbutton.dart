import 'package:flutter/material.dart';

class DialogHelperButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backColor;

  final VoidCallback onTap;
  const DialogHelperButton({super.key,required this.text,required this.textColor, required this.backColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(backColor), // Green background
        padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 12, horizontal: 30)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
      ),
      child:  Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
