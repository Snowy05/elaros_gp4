import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elaros_gp4/Controller/user_data_retrieve.dart';
import 'package:elaros_gp4/View/Education/education_view.dart';
import 'package:elaros_gp4/View/Profiles/select_profile_dashboard_view.dart';
import 'package:elaros_gp4/View/Questionaire/questionaire_view.dart';
import 'package:elaros_gp4/View/Settings/settings_view.dart';
import 'package:elaros_gp4/View/Sleep%20Goal/sleep_plan_view.dart';
import 'package:elaros_gp4/View/Sleep%20Tracker/sleep_tracker_view.dart';
import 'package:elaros_gp4/View/Profiles/Profile%20History/profile_history_view.dart';
import 'package:elaros_gp4/Widgets/Buttons/button_guide_style.dart';
import 'package:elaros_gp4/Widgets/Buttons/button_start_track_style.dart';
import 'package:elaros_gp4/Services/logout_function.dart';
import 'package:elaros_gp4/Widgets/custom_bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_viewlist_resources.dart';

AudioPlayer dashboardAudioPlayer = AudioPlayer(); // global variables for sound
bool isMusicPlaying = false;

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 1;
  String? factDashboard;

  @override
  void initState() {
    super.initState();
    loadFunFact();
    _playBackgroundMusic();
  }

  void _playBackgroundMusic() async {
    final prefs = await SharedPreferences.getInstance();
    final isMusicEnabled = prefs.getBool('music_enabled') ?? true;

    if (!isMusicEnabled || isMusicPlaying) return;

    await dashboardAudioPlayer.setReleaseMode(ReleaseMode.loop);
    await dashboardAudioPlayer.play(AssetSource('backgroundmusic.mp3'));
    isMusicPlaying = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadFunFact() async {
    String? factRetrieve = await getRandomFunFact();
    setState(() {
      factDashboard = factRetrieve;
    });
  }

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

  Future<bool> _isSleepPlanAvailable() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists &&
          (snapshot.data() as Map<String, dynamic>).containsKey("sleep_plan")) {
        return true;
      }
    } catch (e) {
      print("Error checking sleep plan availability: $e");
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 24, 30, 58),
        title: const Text(
          "Dashboard",
          style: TextStyle(
            color: Color.fromARGB(255, 252, 174, 41),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => _logout(context),
                child: Row(
                  children: const [
                    Icon(
                      Icons.logout,
                      color: Color.fromARGB(255, 252, 174, 41),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Logout",
                      style: TextStyle(
                        color: Color.fromARGB(255, 252, 174, 41),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/blue-phone-0njfrpcuzj98bp30.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // LOGO+NAME
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 5,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/SleepyFoxLogo512.png',
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(width: 10),
                    UserNameDisplay(),
                  ],
                ),
              ),
              // SLIDING FIRST PART OF DASHBOARD
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InfoContainer(
                          onPressed: () {
                            Navigator.pushNamed(context, '/EducationView');
                          },
                          title: 'Sleep Hygiene',
                          subtitle: 'Sleeping Techniques',
                          imagePath: 'assets/GirlSleep.jpeg',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InfoContainer(
                          onPressed: () {
                            Navigator.pushNamed(context, '/EducationView');
                          },
                          title: 'Sleep Cycle',
                          subtitle: 'Deep & REM Sleep',
                          imagePath: 'assets/FoxMascProfPic.png',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InfoContainer(
                          onPressed: () {
                            Navigator.pushNamed(context, '/SleepStoryView');
                          },
                          title: 'Bedtime Stories',
                          subtitle: 'Click to Read',
                          imagePath: 'assets/ProfPicKid.png',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // SLEEPYFOX FEATURES PART
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2),
                    _featureItem(
                      'Profiles',
                      SelectProfileView(),
                      'assets/profileboy.png',
                      'Manage Your Child\'s Profile',
                    ),
                    Center(
                      child: FutureBuilder<bool>(
                        future: _isSleepPlanAvailable(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Show a loader while checking
                          }

                          if (snapshot.hasData && snapshot.data == true) {
                            // Show the Sleep Plan button if the sleep plan is available
                            return _featureItem(
                              'Sleep Plan',
                              SleepPlan(),
                              'assets/rabbitreadingfix.png',
                              'View Your Sleep Plan',
                            );
                          }

                          // If the sleep plan is not available, return an empty container
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    Center(
                      child: FutureBuilder<bool>(
                        future: _isSleepPlanAvailable(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (snapshot.hasData && snapshot.data == false) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          QuestionnaireView()),
                                );
                              },
                              child: Card(
                                elevation: 12,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                shadowColor: Colors.black.withOpacity(0.4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 25, 27, 53),
                                        Color.fromARGB(255, 28, 29, 53),
                                        Color.fromARGB(255, 32, 52, 111),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  width: double.infinity,
                                  height: 171,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 28),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                "Questionnaire",
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  color: Colors.amber,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              const Text(
                                                "Complete the questionnaire to unlock your Sleep Plan!",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(80),
                                          child: Image.asset(
                                            'assets/ProfPicKid.png',
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    _featureItem(
                      'Did You Know?',
                      EducationView(),
                      'assets/rabbitreadingfix.png',
                      factDashboard,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _featureItem(String title, Widget page, String imagePath,
      [String? subText]) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        shadowColor: Colors.black.withOpacity(0.4),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 25, 27, 53),
                Color.fromARGB(255, 28, 29, 53),
                Color.fromARGB(255, 32, 52, 111),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          width: double.infinity,
          height: 171,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.amber,
                        ),
                      ),
                      if (subText != null) ...[
                        SizedBox(height: 8),
                        Text(
                          subText,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(80), // circular image
                  child: Image.asset(
                    imagePath,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoBox(String label, String value, {bool isButton = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.black54)),
        SizedBox(height: 4),
        isButton
            ? ElevatedButton(
                onPressed: () {},
                child: Text(value),
              )
            : Text(value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
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

  Future<String?> getRandomFunFact() async {
    try {
      // all documents from the FunFacts collection
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('FunFacts').get();

      // checks if collection is empty
      if (snapshot.docs.isEmpty) {
        print('No fun facts found.');
        return null;
      }

      // random document gets picked
      int randomIndex = Random().nextInt(snapshot.docs.length);
      DocumentSnapshot randomDoc = snapshot.docs[randomIndex];

      // returns the fact thats stored in the document
      return randomDoc['fact'] as String?;
    } catch (e) {
      print('Error fetching fun fact: $e');
      return null;
    }
  }
}
