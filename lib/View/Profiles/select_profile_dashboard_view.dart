import 'package:elaros_gp4/View/Dashboard/dashboard_view.dart';
import 'package:elaros_gp4/View/Settings/settings_view.dart';
import 'package:elaros_gp4/View/Sleep%20Tracker/sleep_tracker_view.dart';
import 'package:elaros_gp4/Widgets/Buttons/button_guide_style.dart';
import 'package:elaros_gp4/Widgets/PopUp/profile_sharecode_input_popup.dart';
import 'package:elaros_gp4/Widgets/Text%20Styles/text_input_style.dart';
import 'package:elaros_gp4/Widgets/custom_bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Services/logout_function.dart';
import 'package:elaros_gp4/Services/profile_services.dart';

class SelectProfileView extends StatefulWidget {
  const SelectProfileView({super.key});

  @override
  State<SelectProfileView> createState() => _SelectProfileViewState();
}

class _SelectProfileViewState extends State<SelectProfileView> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SleepTracking()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardView()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SettingsView()),
      );
    } else if (index != 2) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, "/Login");
      print("User logged out");
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  final ProfileServices _profileServices = ProfileServices();
  List<Map<String, dynamic>> _profiles = [];
  bool _isLoading = true;

  // Fetch profiles with error handling
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
        backgroundColor:
            Color.fromARGB(255, 24, 30, 58), // Dark blue background
        title: Text(
          "Profiles",
          style: TextStyle(
            color: const Color.fromARGB(
                255, 252, 174, 41), // Amber color for title text
          ),
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 216, 163, 6)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/900w-xy8Cv39_lA0.png'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 400,
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _profiles.isEmpty
                      ? Center(child: Text("Profile Not Found"))
                      : ListView.builder(
                          itemCount: _profiles.length,
                          itemBuilder: (context, index) {
                            var profile = _profiles[index];

                            print(
                                "Profile index: $index, Profile name: ${profile['name']}");

                            // Ensure that the profile exists before navigating
                            return _profileCard(
                              index,
                              profile['name'],
                              'assets/FemaleFoxPic.png',
                              () {
                                if (_profiles.length > index) {
                                  Navigator.pushNamed(
                                    context,
                                    '/ManageProfileView',
                                    arguments: index,
                                  );
                                } else {
                                  print("Invalid profile index: $index");
                                }
                              },
                            );
                          },
                        ),
            ),
            SizedBox(height: 80),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 23, 28, 55),
                      Colors.blueGrey.shade700
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      GuideButton(
                        text: "Create a New Profile",
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.grey[100],
                                  elevation: 20,
                                  shadowColor: Colors.amber.withOpacity(0.5),
                                  insetPadding: EdgeInsets.all(20),
                                  contentPadding: EdgeInsets.all(20),
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(color: Colors.amber),
                                  ),
                                  title: Text('Create Profile'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextInputStyle(
                                          controller: nameController,
                                          labelText: 'Name'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextInputStyle(
                                          controller: ageController,
                                          labelText: 'Age'),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel')),
                                    TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.amber,
                                          foregroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                        ),
                                        onPressed: () async {
                                          final String name =
                                              nameController.text;
                                          final String ageText =
                                              ageController.text;
                                          if (name.isEmpty || ageText.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Name and Age are required"),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            return;
                                          }
                                          final int? age =
                                              int.tryParse(ageText);
                                          if (age == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Age has to be a number!'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            return;
                                          }
                                          if (age <= 0 || age > 13) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Age has to be between 1 and 13!'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            return;
                                          }
                                          final String? email = FirebaseAuth
                                              .instance.currentUser?.email;
                                          if (email == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'User not logged in.'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            return;
                                          }

                                          await _profileServices
                                              .addChildProfile(
                                                  name, age, email);
                                          await _fetchProfiles();
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Profile created successfully!'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        },
                                        child: Text('Create'))
                                  ],
                                );
                              });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GuideButton(
                          text: 'Add With Share Code',
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return ProfileInputPopUp(
                                    hint: 'Share Code',
                                    title: 'Add Profile',
                                    //File Found in widgets/PopUp/profile_sharecode_input_popup.dart
                                  );
                                });
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      GuideButton(
                        text: 'Sleep History',
                        onPressed: () {
                          Navigator.pushNamed(context, '/SleepHistory');
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _profileCard(
      int index, String title, String imagePath, VoidCallback? onTap) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 23, 28, 55), Colors.blueGrey.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(imagePath),
          ),
          title: Text(title ?? '',
              style: TextStyle(fontSize: 16, color: Colors.amber)),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 30,
            color: Colors.amber,
          ),
          onTap: onTap,
        ),
      ),
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
