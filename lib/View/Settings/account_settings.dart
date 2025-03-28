import 'package:elaros_gp4/Widgets/Buttons/button_guide_style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elaros_gp4/Widgets/custom_bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elaros_gp4/View/Settings/settings_view.dart';

import '../../Widgets/Buttons/delete_button.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  int _selectedIndex = 2;

  String _username = "";
  String _maskedEmail = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      final data = doc.data();

      if (data != null && mounted) {
        setState(() {
          _username = data['username'] ?? 'No username';
          _maskedEmail = _maskEmail(currentUser.email ?? '');
        });
      }
    }
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2 || parts[0].length < 2) return "**protected**";
    return parts[0].substring(0, 2) + "*******@" + parts[1];
  }

  void _deleteAccount() async {
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
            "Are you sure you want to delete your account? This cannot be undone."),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.amber,
            ),
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final userId = currentUser.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .delete();

        final providerData = currentUser.providerData;
        if (providerData.isNotEmpty) {
          final email = currentUser.email;
          final auth = FirebaseAuth.instance;

          if (email != null) {
            final methods = await auth.fetchSignInMethodsForEmail(email);
            if (methods.contains('password')) {
              await currentUser.delete();
            }
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account deletion failed. Please try again.')),
      );
    } finally {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/Login', (route) => false);
    }
  }

  void _confirmChangePassword() async {
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Password"),
        content: const Text("Are you sure you want to change your password?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                const Text("Continue", style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      Navigator.pushReplacementNamed(context, '/ResetPassword');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/SleepTracking');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/Dashboard');
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SettingsView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor:
            Color.fromARGB(255, 24, 30, 58), // Dark blue background
        title: Text(
          "Account",
          style: TextStyle(
            color: const Color.fromARGB(
                255, 252, 174, 41), // Amber color for title text
          ),
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 216, 163, 6)),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(220, 10, 18, 43),
              Color.fromARGB(255, 28, 29, 53),
              Color.fromARGB(255, 25, 27, 53),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    shadowColor: Colors.black.withOpacity(0.4),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(220, 10, 18, 43),
                            Color.fromARGB(255, 28, 29, 53),
                            Color.fromARGB(255, 25, 27, 53),
                          ],
                        ),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 50, horizontal: 25),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade800,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Username:",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white70)),
                                const SizedBox(height: 4),
                                Text(_username,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 16),
                                Text("Email:",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white70)),
                                const SizedBox(height: 4),
                                Text(_maskedEmail,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 35),
                          GuideButton(
                              text: 'Change Password',
                              onPressed: _confirmChangePassword),
                          // ElevatedButton(
                          //   onPressed: _confirmChangePassword,
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Colors.orange,
                          //     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          //   ),
                          //   child: const Text("Change Password"),
                          // ),
                          const SizedBox(height: 20),
                          DeleteButton(
                              text: 'Delete Account',
                              onPressed: _deleteAccount),
                          // ElevatedButton(
                          //   onPressed: _deleteAccount,
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Colors.red,
                          //     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          //   ),
                          //   child: const Text("Delete Account"),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
