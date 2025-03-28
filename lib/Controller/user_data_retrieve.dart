import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDataRetrieveService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getUserName() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          return userDoc['username'];
        } else {
          print('DEBUG: User document does not exist');
          return null;
        }
      } else {
        print('DEBUG: No user is currently logged in');
        return null;
      }
    } catch (e) {
      print('DEBUG: Error retrieving user name → \${e.toString()}');
      return null;
    }
  }
}

class UserNameDisplay extends StatelessWidget {
  const UserNameDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: UserDataRetrieveService().getUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            'Loading...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 252, 174, 41),
            ),
          );
        }
        if (snapshot.hasError) {
          return Text(
            'Error',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 252, 174, 41),
            ),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return Text(
            snapshot.data!,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 202, 104),
            ),
          );
        }
        return Text(
          'User not found',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 252, 174, 41),
          ),
        );
      },
    );
  }
}
