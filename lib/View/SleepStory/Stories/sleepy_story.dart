import 'package:flutter/material.dart';
import 'package:elaros_gp4/View/SleepStory/Sleep_story_card.dart';

import '../../../Widgets/custom_bottom_nav_bar.dart';
import '../../Dashboard/dashboard_view.dart';
import '../../Settings/settings_view.dart';
import '../../Sleep Tracker/sleep_tracker_view.dart';

class SleepyStory extends StatefulWidget {
  const SleepyStory({super.key});

  @override
  State<SleepyStory> createState() => _SleepyStoryState();
}

class _SleepyStoryState extends State<SleepyStory> {
  int _selectedIndex = 1;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
        child: PageView(
          controller: _pageController,
          children: [
            SleepStoryCard(
              title: 'The Sleepless Fox',
              imagePath: 'assets/SleepyFoxStory1.png',
              content:
                  'In the heart of an ancient forest, there lived a charming but restless fox named Finn. While most creatures nestled into dreams as the moon climbed high, Finn’s mind was a swirl of thoughts.',
              contenttwo:
                  'He dreamed of chasing fireflies, counting stars, and pondering the mysteries of the world. But tonight, his thoughts felt heavier than usual.',
              next: 'Finn tried every trick to find sleep...',
            ),
            SleepStoryCard(
              title: 'Tricks for Sleep',
              imagePath: 'assets/FoxStory3.png',
              content:
                  'One particular night, bathed in a silver moonbeam, Finn burrowed into his softest moss bed. He hummed soothing tunes, hoping to coax sleep to his side.',
              contenttwo:
                  'He even tried counting tree leaves swaying gently in the cool forest breeze. But nothing worked. His eyes stayed wide open, reflecting the shimmering constellations above.',
              next: 'Just as Finn was about to give up, he heard a voice...',
            ),
            SleepStoryCard(
              title: 'Moonlit Whisper',
              imagePath: 'assets/OwlStory1.png',
              content:
                  'A wise old owl named Ophelia swooped down, her feathers gleaming like silver threads under the moonlight. "Finn," she cooed, "I’ve watched you toss and turn."',
              contenttwo:
                  '"Perhaps the forest itself can lull you into slumber—if you learn its melody." Intrigued, Finn pricked his ears and listened.',
              next: 'The forest’s sounds started weaving a melody...',
            ),
            SleepStoryCard(
              title: 'Dreamsong',
              imagePath: 'assets/ProfPicKid.png',
              content:
                  'As Finn hummed along, his heartbeat slowed, matching the rhythm of the forest\'s melody. A warmth spread through him, like moonlight wrapping him in a soft embrace.',
              contenttwo:
                  'Before he knew it, his eyelids grew heavy, and Finn drifted into a peaceful slumber. The stars above twinkled brighter, celebrating the fox who found his dreamsong.',
              next:
                  'Every night thereafter, Finn hummed his melody, and the forest sang back...',
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
}
