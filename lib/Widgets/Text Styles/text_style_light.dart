import 'package:flutter/material.dart';

class StrokeTextLight extends StatelessWidget {
  final String text;
  final TextStyle textStyle;

  const StrokeTextLight({
    required this.text,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Stroke
        Text(
          text,
          style: textStyle.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..color = Colors.black, // Stroke color
          ),
        ),
        // Fill
        Text(
          text,
          style: textStyle.copyWith(color: Colors.brown), // Fill color
        ),
      ],
    );
  }
}