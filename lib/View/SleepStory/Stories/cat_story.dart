import 'package:flutter/material.dart';

import '../../../Widgets/custom_bottom_nav_bar.dart';
import '../../Dashboard/dashboard_view.dart';
import '../../Settings/settings_view.dart';
import '../../Sleep Tracker/sleep_tracker_view.dart';
import '../Sleep_story_card.dart';

class CatStory extends StatefulWidget {
  const CatStory({super.key});

  @override
  State<CatStory> createState() => _SleepyStoryState();
}

class _SleepyStoryState extends State<CatStory> {
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
              title: 'Luna the Curious Cat',
              imagePath: 'assets/CatStory3.png',
              content:
                  'In a quiet little town, there lived a curious cat named Luna. She had sleek fur as black as midnight and eyes that sparkled like golden stars.',
              contenttwo:
                  'Luna loved exploring every nook and cranny of the town. But more than anything, she dreamed of climbing to the top of the tallest rooftop to see the entire world.',
              next: 'One moonlit night, Luna spotted the perfect rooftop...',
            ),
            SleepStoryCard(
              title: 'The First Leap',
              imagePath: 'assets/CatStory1.png',
              content:
                  'With her tail swishing, Luna crouched low and leapt onto the first ledge. The wind brushed her whiskers as she balanced carefully on the edge.',
              contenttwo:
                  '"Almost there!" she thought, her heart racing with excitement. Her paws barely made a sound as she padded toward the next jump.',
              next: 'Suddenly, she heard a soft chirping sound...',
            ),
            SleepStoryCard(
              title: 'A Feathered Friend',
              imagePath: 'assets/Sparrow1.png',
              content:
                  'Perched on a nearby branch was a tiny, fluffy sparrow. "What are you doing up here, Luna?" chirped the bird. "I’m climbing to the top of the world," Luna purred.',
              contenttwo:
                  '"Do you want to come with me?" she asked. The sparrow flapped its wings and hopped closer, eager to join the adventure.',
              next: 'Together, they continued the journey...',
            ),
            SleepStoryCard(
              title: 'The Rooftop View',
              imagePath: 'assets/CatStory2.png',
              content:
                  'At last, Luna and her feathered friend reached the top of the tallest rooftop. The town below glittered with tiny lights, and the stars above seemed close enough to touch.',
              contenttwo:
                  '"It’s even more beautiful than I imagined," Luna whispered. She and the sparrow sat side by side, watching the world sparkle until morning.',
              next:
                  'Luna purred softly, already dreaming of her next adventure...',
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
