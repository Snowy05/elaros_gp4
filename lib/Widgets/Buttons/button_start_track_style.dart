import 'package:flutter/material.dart';

class StartTrackingSleepButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final Size minimumSize;
  final double borderRadius;

  StartTrackingSleepButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
    this.fontSize = 14.0,
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
        ),
      ),
      child: Text(text),
    );
  }
}

