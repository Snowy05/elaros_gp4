import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Function to add a child profile
  Future<void> addChildProfile(String name, int age, String email) async {
    CollectionReference childProfiles =
    FirebaseFirestore.instance.collection('childProfiles');

     String shareCode = generateShareCode();    // sharecode function is called and is added to profile   
      try {
        await childProfiles.add({
          'name': name,
          'age': age,
          'emails': [email], // multiple emails can be bound to a profile
          'sharecode' : shareCode,
        });
        print("Child Profile Added");
      } catch (error) {
        print("Failed to add child profile: $error");
      }
  }

  String generateShareCode({int length = 5}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  Future<void> addProfileByShareCode(String email, String shareCode) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot childQuery = await firestore
          .collection('childProfiles')
          .where('sharecode', isEqualTo: shareCode)
          .limit(1) // error handling for any instances of multiple sharecodes present
          .get();

      if (childQuery.docs.isEmpty) {
        print("No child profile found with that share code.");
        return;
      }

      DocumentSnapshot childDoc = childQuery.docs.first;

      await childDoc.reference.update({
        'emails': FieldValue.arrayUnion([email]) // updates email list of the profile to include the users
      });

      print("Email $email added to child profile.");
    } catch (error) {
      print("Failed to add user email to child profile: $error");
    }
  }
  // Fetch all profiles (not filtered)
  Future<List<Map<String, dynamic>>> fetchChildProfiles() async {
    CollectionReference childProfiles =
        FirebaseFirestore.instance.collection('childProfiles');

    QuerySnapshot querySnapshot = await childProfiles.get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
  //DELETE PROFILE FUNC
  Future<void> deleteProfile(String profileId) async {
    try {
      await _firestore.collection('childProfiles').doc(profileId).delete();
      print('Profile Deleted');
    } catch (e) {
      print("Failed to delete profile: $e");
    }
  }

  // Fetch profiles associated with the logged-in user's email
  Future<List<Map<String, dynamic>>> fetchChildProfilesForCurrentUser() async {
    try {
      final String? userEmail = _auth.currentUser?.email;
      if (userEmail == null) {
        throw Exception("User is not logged in.");
      }

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('childProfiles')
          .where('emails', arrayContains: userEmail) // changed to arrayContains, this checks if any email equals the userEmail
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Failed to fetch child profiles for current user: $e");
      return [];
    }
  }

  Future<String?> getShareCode(String profileId) async {
    try {
      DocumentSnapshot profileDoc = await _firestore.collection('childProfiles').doc(profileId).get();
      if (profileDoc.exists) { // checks if retrieved profile is not empty
        return profileDoc['sharecode'] as String?; // returns sharecode if succesfull
      } else {
        print("Profile not found");
        return null;
      }
    } catch (e) {
      print("Failed to retrieve sharecode: $e");
      return null;
    }
  }
}
