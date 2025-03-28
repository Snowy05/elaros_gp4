import 'package:flutter/material.dart';
import 'package:elaros_gp4/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final AuthService _authService = AuthService();

  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid; // Returns null if no user is logged in
  }

  bool IfValidEmail(String email) {
    final emailChecker = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailChecker.hasMatch(email);
  }

  bool isValidPassword(String password) {
    return password.length >= 6 && password.length <= 50;
  }

  /// Handles user sign-up
  Future<bool> signUp(String username, String email, String password,
      BuildContext context) async {
    if (username.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty) {
      _showErrorMessage(
          context, "Username, email, or password cannot be empty.");
      return false;
    }

    if (!IfValidEmail(email)) {
      _showErrorMessage(context, "Please enter a valid email address.");
      return false;
    }
    if (!isValidPassword(password)) {
      _showErrorMessage(
          context, "Password must be between 6 and 50 characters.");
      return false;
    }

    String? errorMessage = await _authService.signUp(email, password);

    if (errorMessage == null) {
      // Store the username in Firestore or your chosen database
      await _authService.storeUserProfile(username, email);
      return true; // Sign-up successful
    } else {
      final signUpCustomMessage =
          _SignUpFormatErrorMessage(errorMessage.trim());
      _showErrorMessage(context, signUpCustomMessage);
      return false;
    }
  }

  String _SignUpFormatErrorMessage(String errorCode) {
    errorCode = errorCode.trim().toLowerCase();

    switch (errorCode) {
      case "email-already-in-use":
        return "This email is already registered, try logging in.";
      case "email-already-exists":
        return "This email is already registered, try logging in.";
      default:
        return "An unexpected error occurred, please try again.";
    }
  }

  /// Handles user login
  Future<bool> loginUser(
      String email, String password, BuildContext context) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      _showErrorMessage(context,
          "Looks like either your email address or password were incorrect, please try again.");
      return false;
    }

    if (!IfValidEmail(email)) {
      _showErrorMessage(context,
          "Looks like either your email address or password were incorrect, please try again.");
      return false;
    }

    String? errorMessage = await _authService.login(email, password);

    if (errorMessage == null) {
      return true; // Login successful
    } else {
      //  Uncommented: Now it properly handles login errors
      final loginCustomMessage = _LoginFormatErrorMessage(errorMessage.trim());
      _showErrorMessage(context, loginCustomMessage);
      return false;
    }
  }

  String _LoginFormatErrorMessage(String errorCode) {
    errorCode = errorCode.trim().toLowerCase();

    switch (errorCode) {
      case "user-not-found":
        return "Looks like either your email address or password were incorrect, please try again.";
      case "invalid-credential":
        return "Looks like either your email address or password were incorrect, please try again.";
      default:
        return "An unexpected error occurred, please try again.";
    }
  }

  /// Shows an error message using Snackbar
  void _showErrorMessage(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}

extension on AuthService {
  storeUserProfile(String username, String email) {}
}
