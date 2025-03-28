import 'package:flutter/material.dart';

class ZaksPersonalTextStyle extends StatelessWidget {
  final String text;
  final TextStyle textStyle;

  const ZaksPersonalTextStyle({
    required this.text,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: textStyle.copyWith(color: Colors.black, letterSpacing: 0.1), // Fill color
        ),
      ],
    );
  }
}