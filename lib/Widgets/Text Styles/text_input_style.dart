import 'package:flutter/material.dart';

class TextInputStyle extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  TextInputStyle({required this.controller, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Colors.amber,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
      ),
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
    );
  }
}
