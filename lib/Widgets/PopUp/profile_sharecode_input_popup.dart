import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:elaros_gp4/Services/profile_services.dart';

class ProfileInputPopUp extends StatelessWidget {
  final String title;
  final String hint;

  const ProfileInputPopUp({required this.hint, required this.title, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _sharecodecontroller = TextEditingController();
    final ProfileServices _profileServices = ProfileServices();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.amberAccent.withOpacity(0.7),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _sharecodecontroller,
              decoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  onPressed: () async {
                    String inputCode = _sharecodecontroller.text;
                    Navigator.of(context).pop(inputCode);
                    final String? email = FirebaseAuth.instance.currentUser?.email;
                    if (email == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User not logged in.')),
                      );
                      return;
                    }
                    await _profileServices.addProfileByShareCode(email,inputCode);
                    await _profileServices.fetchChildProfilesForCurrentUser();
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
