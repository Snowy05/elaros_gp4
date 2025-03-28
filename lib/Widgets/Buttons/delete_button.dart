import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final Size minimumSize;
  final double borderRadius;

  DeleteButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.red,
    this.textColor = Colors.black,
    this.fontSize = 16.0,
    this.minimumSize = const Size(double.infinity, 50),
    this.borderRadius = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: backgroundColor,
        minimumSize: minimumSize,
        textStyle: TextStyle(fontSize: fontSize),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: Colors.black), // Adding black border
        ),
      ),
      child: Text(text),
    );
  }
}

