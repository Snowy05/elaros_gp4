import 'package:flutter/material.dart';

class WelcomeTextStyle extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;

  const WelcomeTextStyle({
    Key? key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}


