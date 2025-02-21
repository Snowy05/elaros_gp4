import 'package:elaros_gp4/Widgets/Buttons/button_guide_style.dart';
import 'package:elaros_gp4/Widgets/Text%20Styles/text_style_black.dart';
import 'package:elaros_gp4/Widgets/Text%20Styles/text_style_light.dart';
import 'package:elaros_gp4/Widgets/Text%20Styles/zaks_personal_text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:elaros_gp4/Services/profile_services.dart';

import '../../../Widgets/Buttons/logout_function.dart';

class ManageProfileView extends StatefulWidget {
  const ManageProfileView({super.key});

  @override
  State<ManageProfileView> createState() => _ManageProfileViewState();
}

class _ManageProfileViewState extends State<ManageProfileView> {
  final ProfileServices _profileServices = ProfileServices();
  List<Map<String, dynamic>> _profiles = [];
  bool _isLoading = true;

  @override
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 4) {
      setState(() {
        logout(context);
      });
    }
    if (index != 2) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

//logout function
  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, "/Login");
      print("User logged out");
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  void initState() {
    super.initState();
    _fetchProfiles();
  }

  Future<void> _fetchProfiles() async {
    try {
      List<Map<String, dynamic>> profiles =
          await _profileServices.fetchChildProfilesForCurrentUser();
      setState(() {
        _profiles = profiles;
        _isLoading = false;
      });
    } catch (error) {
      print("Failed to fetch profiles: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 234, 235, 235),
        title: Text("Profiles"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text("Sleepy fox"),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // TOP PROFILE SECTION
            Padding(
              padding: const EdgeInsets.all(8.2),
              child: Card(
                color: Colors.grey[200],
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    // PROFILE PICTURE
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Image.asset(
                          "Assets/SleepyFoxLogo512.png",
                          width: 100,
                          height: 100,
                        ),
                        _isLoading
                            ? CircularProgressIndicator()
                            : Column(
                                children: [
                                  ZaksPersonalTextStyle(
                                    text: _profiles.isNotEmpty
                                        ? _profiles[0]['name']
                                        : 'No Profile',
                                    textStyle: TextStyle(fontSize: 40),
                                  ),
                                  Container(
                                    height: 0,
                                  ),
                                  ZaksPersonalTextStyle(
                                    text:
                                        "Age: ${_profiles.isNotEmpty ? _profiles[0]['age'].toString() : 'No Age'}",
                                    textStyle: TextStyle(fontSize: 30),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Decorative Bar
            SizedBox(
              height: 50,
            ),

            Padding(
              padding: const EdgeInsets.all(8.2),
              child: Card(
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ZaksPersonalTextStyle(
                          text: 'Sleep Analysis',
                          textStyle: TextStyle(fontSize: 30)),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Average Sleep Duration',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black)),
                            SizedBox(height: 5),
                            Text('7.5 hours',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            SizedBox(height: 15),
                            Divider(
                              indent: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ZaksPersonalTextStyle(
                                    text: 'Current Mood:',
                                    textStyle: TextStyle(fontSize: 20)),
                                Text('Missing Khalid :(')
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // PROFILE SLEEP ANALYSIS
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    GuideButton(text: 'Delete Profile', onPressed: () {}),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, "Home", 0),
            _buildNavItem(Icons.nightlight_round, "Sleep", 1),
            const SizedBox(width: 48), // Space for floating button
            _buildNavItem(Icons.settings, "Settings", 3),
            _buildNavItem(Icons.logout, "Sign Out", 4),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color.fromARGB(255, 233, 166, 90),
        shape: const CircleBorder(),
        child: Image.asset(
          "Assets/SleepyFoxLogo512.png",
          width: 40,
          height: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:
              isSelected ? Colors.amber.withOpacity(0.2) : Colors.transparent,
        ),
        child: SizedBox(
          height: 56, // OVERFLOW FIX
          width: 60, // same width on all devices
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: isSelected ? 0 : 4, // Moves up when selected
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  height: isSelected ? 28 : 24, // Adjusts size without scaling
                  child: Icon(icon,
                      color: isSelected ? Colors.amber.shade700 : Colors.black,
                      size: isSelected ? 28 : 24),
                ),
              ),
              Positioned(
                bottom: 0, // Fixes text position
                child: AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.amber.shade700 : Colors.black,
                  ),
                  child: Text(label),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
