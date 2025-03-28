import 'package:audioplayers/audioplayers.dart';
import 'package:elaros_gp4/View/Dashboard/dashboard_view.dart';
import 'package:elaros_gp4/View/Sleep%20Tracker/sleep_tracker_view.dart';
import 'package:elaros_gp4/Widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elaros_gp4/View/Dashboard/dashboard_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  int _selectedIndex = 2;
  bool _isMusicEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadMusicSetting();
  }

  void _loadMusicSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isMusicEnabled = prefs.getBool('music_enabled') ?? true;
    });
  }

  void _toggleMusic(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('music_enabled', value);
    setState(() {
      _isMusicEnabled = value;
    });
    
      if (value) {
      // music turns on
      if (!isMusicPlaying) {
        await dashboardAudioPlayer.setReleaseMode(ReleaseMode.loop);
        await dashboardAudioPlayer.play(
          AssetSource('backgroundmusic.mp3'),
          volume: 0.5,
        );
        isMusicPlaying = true;
      }
    } else {
      // music turns off
      await dashboardAudioPlayer.stop();
      isMusicPlaying = false;
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:
            Color.fromARGB(255, 24, 30, 58), // Dark blue background
        title: Text(
          "Settings",
          style: TextStyle(
            color: const Color.fromARGB(
                255, 252, 174, 41), // Amber color for title text
          ),
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 216, 163, 6)),
      ),
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              // Glowing Settings Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                shadowColor: Colors.black.withOpacity(0.4),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 25, 27, 53),
                        Color.fromARGB(255, 28, 29, 53),
                        Color.fromARGB(255, 24, 39, 83),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading:
                            Icon(Icons.person, color: Colors.amber, size: 34),
                        title: Text("Account",
                            style:
                                TextStyle(color: Colors.amber, fontSize: 20)),
                        onTap: () {
                          Navigator.pushNamed(context, '/AccountSettings');
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.notifications,
                            color: Colors.amber, size: 34),
                        title: Text("Notifications",
                            style:
                                TextStyle(color: Colors.amber, fontSize: 20)),
                        onTap: () {
                          Navigator.pushNamed(context, '/Notifications');
                        },
                      ),
                      ListTile(
                        leading:
                            Icon(Icons.lock, color: Colors.amber, size: 34),
                        title: Text("Privacy",
                            style:
                                TextStyle(color: Colors.amber, fontSize: 20)),
                        onTap: () {
                          Navigator.pushNamed(context, '/PrivacySettings');
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.question_mark,
                            color: Colors.amber, size: 34),
                        title: Text("Guide",
                            style:
                                TextStyle(color: Colors.amber, fontSize: 20)),
                        onTap: () {
                          Navigator.pushNamed(context, '/GuideView');
                        },
                      ),
                      ListTile(
                        leading:
                            Icon(Icons.help, color: Colors.amber, size: 34),
                        title: Text("About Us",
                            style:
                                TextStyle(color: Colors.amber, fontSize: 20)),
                        onTap: () {
                          Navigator.pushNamed(context, '/AboutUs');
                        },
                      ),
                      SwitchListTile(
                        title: Text("Music",
                            style:
                                TextStyle(color: Colors.amber, fontSize: 20)),
                        secondary: Icon(Icons.music_note,
                            color: Colors.amber, size: 34),
                        value: _isMusicEnabled,
                        onChanged: _toggleMusic,
                        activeColor: Colors.amber,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Colors.black,
                                title: const Text(
                                  "Confirm Sign Out",
                                  style: TextStyle(color: Colors.amber),
                                ),
                                content: const Text(
                                  "Are you sure you want to sign out?",
                                  style: TextStyle(color: Colors.white),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel",
                                        style: TextStyle(color: Colors.amber)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close dialog
                                      Navigator.pushReplacementNamed(
                                          context, '/Login'); // Navigate
                                    },
                                    child: const Text("Sign Out",
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                255, 128, 13, 13), // Your dark red
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Sign Out",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
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
}
