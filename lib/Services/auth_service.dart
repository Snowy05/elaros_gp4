import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Handles user sign-up
  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } on FirebaseAuthException catch (e) { // 🔹 Catch specific Firebase errors
      return e.code; // Return only the Firebase error code
    } catch (e) {
      print("DEBUG: Unexpected Error → ${e.toString()}"); // Debugging unknown errors
      return "unexpected-error"; // Generic fallback error
    }
  }

  /// Stores user profile with username
  Future<void> storeUserProfile(String username, String email) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        print("DEBUG: No current user logged in.");
      }
    } catch (e) {
      print("DEBUG: Error storing user profile → ${e.toString()}");
    }
  }

  /// Handles user login
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } on FirebaseAuthException catch (e) { // 🔹 Catch specific Firebase errors
      print("DEBUG: FirebaseAuthException Code → ${e.code}"); // Debugging
      return e.code; // Return only the Firebase error code
    } catch (e) {
      print("DEBUG: Unexpected Error → ${e.toString()}"); // Debugging unknown errors
      return "unexpected-error"; // Generic fallback error
    }
  }
}
