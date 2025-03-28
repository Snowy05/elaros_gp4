import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, "/Login");
    print("User logged out");
  } catch (e) {
    print("Error logging out: $e");
  }
}
