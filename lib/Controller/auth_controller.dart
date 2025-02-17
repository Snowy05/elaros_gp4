import 'package:flutter/material.dart';
import 'package:elaros_gp4/services/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<bool> loginUser(
      String email, String password, BuildContext context) async {
    String? errorMessage = await _authService.login(email, password);

    if (errorMessage == null) {
      return true; // Login successful
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: $errorMessage")),
        );
      }
      return false;
    }
  }
}
