import 'package:elaros_gp4/View/SleepStory/sleepy_fox_card.dart';
import 'package:elaros_gp4/Widgets/Text%20Styles/zaks_personal_text_style.dart';
import 'package:flutter/material.dart';

import '../../Widgets/custom_bottom_nav_bar.dart';
import '../Dashboard/dashboard_view.dart';
import '../Settings/settings_view.dart';
import '../Sleep Tracker/sleep_tracker_view.dart';

class SleepStoryView extends StatefulWidget {
  const SleepStoryView({super.key});

  @override
  State<SleepStoryView> createState() => _SleepStoryViewState();
}

class _SleepStoryViewState extends State<SleepStoryView> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Color.fromARGB(255, 24, 30, 58), // Dark blue background
        title: Text(
          "Bedtime Stories",
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              SleepyFoxCard(
                title: "The Sleepy Fox",
                imagePath: 'assets/FoxMascProfPic.png',
                routeName: '/TheSleepyStory',
              ),
              SizedBox(height: 10),
              SleepyFoxCard(
                title: "Bruno The Bear",
                imagePath: 'assets/bearstory1.png',
                routeName: '/BearStory',
              ),
              SizedBox(height: 10),
              SleepyFoxCard(
                title: "Barkley's Story",
                imagePath: 'assets/Dog1.png',
                routeName: '/DogStory',
              ),
              SizedBox(height: 10),
              SleepyFoxCard(
                title: "Luna's Story",
                imagePath: 'assets/CatStory1.png',
                routeName: '/CatStory',
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
