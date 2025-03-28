import 'package:flutter/material.dart';

import '../../../Widgets/custom_bottom_nav_bar.dart';
import '../../Dashboard/dashboard_view.dart';
import '../../Settings/settings_view.dart';
import '../../Sleep Tracker/sleep_tracker_view.dart';
import '../Sleep_story_card.dart';

class BearStory extends StatefulWidget {
  const BearStory({super.key});

  @override
  State<BearStory> createState() => _SleepyStoryState();
}

class _SleepyStoryState extends State<BearStory> {
  int _selectedIndex = 1;
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
          children: [
            SleepStoryCard(
              title: 'Bruno the Sleepy Bear',
              imagePath: 'assets/BearStory2.png',
              content:
                  'Deep in the heart of a quiet forest, there lived a big, gentle bear named Bruno. Bruno loved two things more than anything else—naps and honey.',
              contenttwo:
                  'But one chilly autumn morning, Bruno found himself unable to sleep. His cozy cave just didn’t feel right, and his dreams refused to come.',
              next: 'Bruno decided to go on a little adventure...',
            ),
            SleepStoryCard(
              title: 'Searching for Comfort',
              imagePath: 'assets/bearstory1.png',
              content:
                  'Bruno wandered through the forest, hoping to find something that would help him sleep. He stopped by the bubbling brook, listening to its soothing sounds.',
              contenttwo:
                  'But even the calming water couldn’t make Bruno yawn. "Maybe my friends can help," he thought, and he padded off toward the meadow.',
              next: 'Bruno’s first stop was at a hollow tree...',
            ),
            SleepStoryCard(
              title: 'Advice from the Bees',
              imagePath: 'assets/BearStory3.png',
              content:
                  'At the hollow tree, a hive of friendly bees buzzed around. "Bruno, try a spoonful of honey before bed!" they suggested. "It always makes us feel sweet and sleepy."',
              contenttwo:
                  'Bruno thanked the bees and enjoyed a golden drop of honey. It was delicious, but it didn’t bring him the sleepy feeling he hoped for.',
              next: 'Next, Bruno visited the wise old owl...',
            ),
            SleepStoryCard(
              title: 'A Bedtime Secret',
              imagePath: 'assets/OwlStory1.png',
              content:
                  'The wise old owl hooted softly from her perch. "Bruno, your cave might be missing its special bedtime touch. Gather some leaves and pine needles to make it extra cozy."',
              contenttwo:
                  'Bruno thought this was a wonderful idea. He spent the rest of the evening collecting the softest materials he could find for his bed.',
              next: 'At last, Bruno returned to his cave...',
            ),
            SleepStoryCard(
              title: 'The Best Sleep Ever',
              imagePath: 'assets/BearStoryWalking.png',
              content:
                  'Bruno arranged the leaves and pine needles into a fluffy nest. He snuggled in and let out a deep, happy sigh. The cave felt just right now.',
              contenttwo:
                  'As he drifted off to sleep, Bruno dreamed of honey, buzzing bees, and the friendly forest he loved so much. It truly was the best sleep ever.',
              next:
                  'Bruno couldn’t wait to wake up and explore the forest all over again...',
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
