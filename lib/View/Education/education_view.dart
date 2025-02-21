import 'package:elaros_gp4/Widgets/custom_bottom_nav_bar.dart';
import 'package:elaros_gp4/Widgets/education_container.dart';
import 'package:flutter/material.dart';

class EducationView extends StatefulWidget {
  const EducationView({super.key});

  @override
  State<EducationView> createState() => _EducationViewState();
}

class _EducationViewState extends State<EducationView> {
  final ScrollController _scrollController = ScrollController();

  // Global keys for each section
  final GlobalKey _hygieneKey = GlobalKey();
  final GlobalKey _cycleKey = GlobalKey();
  final GlobalKey _habitsKey = GlobalKey();

  // Function to scroll to a section
  void _scrollToSection(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index != 2) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 234, 235, 235),
        title: Text("Education"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text("Sleepy Fox"),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Navigation Buttons
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _scrollToSection(_hygieneKey),
                  child: Text('Good Sleep Hygiene'),
                ),
                ElevatedButton(
                  onPressed: () => _scrollToSection(_cycleKey),
                  child: Text('Sleep Cycle'),
                ),
                ElevatedButton(
                  onPressed: () => _scrollToSection(_habitsKey),
                  child: Text('Healthy Sleep Habits'),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // **Good Sleep Hygiene Section**
                  Padding(
                    key: _hygieneKey,
                    padding: EdgeInsets.only(left: 16, top: 8, bottom: 4),
                    child: Text(
                      'Sleep Hygiene',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(color: Colors.amber, thickness: 1),
                  ),
                  SizedBox(height: 8),
                  InfoCard(
                    title: 'Good Sleep Hygiene',
                    content:
                        'Good sleep hygiene includes a consistent routine, a comfortable sleep environment, '
                        'and healthy habits that promote restful sleep.',
                  ),
                  InfoCard(
                    title: 'Consistent Bedtime Routine',
                    content:
                        'A predictable bedtime routine helps children feel secure and ready for sleep. '
                        'This can include brushing teeth, reading a book, and dimming the lights 30 minutes before bed.',
                  ),
                  InfoCard(
                    title: 'Create a Comfortable Sleep Environment',
                    content:
                        'A cool, dark, and quiet bedroom promotes better sleep. Use blackout curtains, '
                        'a white noise machine if needed, and a comfortable mattress and pillow suitable for their age.',
                  ),
                  InfoCard(
                    title: 'Limit Screen Time Before Bed',
                    content:
                        'Blue light from screens can disrupt melatonin production, making it harder to fall asleep. '
                        'Turn off devices at least one hour before bedtime and encourage quiet activities instead.',
                  ),

                  // **Understanding the Sleep Cycle Section**
                  Padding(
                    key: _cycleKey,
                    padding: EdgeInsets.only(left: 16, top: 8, bottom: 4),
                    child: Text(
                      'Understanding the Sleep Cycle',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(color: Colors.amber, thickness: 1),
                  ),
                  SizedBox(height: 8),
                  InfoCard(
                    title: 'Understanding the Sleep Cycle',
                    content:
                        'Children’s sleep cycles include deep sleep and REM sleep, both essential for growth and brain development. '
                        'Maintaining a consistent sleep schedule helps regulate these cycles.',
                  ),
                  InfoCard(
                    title: 'Age-Appropriate Sleep Duration',
                    content:
                        'Children need different amounts of sleep based on age:\n'
                        '- 2-3 years: 11-14 hours (including naps)\n'
                        '- 4-5 years: 10-13 hours\n'
                        '- 6-13 years: 9-11 hours.\n'
                        'Ensuring they get enough sleep supports growth and learning.',
                  ),
                  InfoCard(
                    title: 'Wake Up at the Same Time Daily',
                    content:
                        'Even on weekends, keeping a consistent wake-up time strengthens the body’s sleep-wake cycle, '
                        'leading to better sleep quality.',
                  ),
                  InfoCard(
                    title: 'No Late Naps for Older Kids',
                    content:
                        'While naps are essential for toddlers, children over 5 should avoid napping too late in the afternoon, '
                        'as it can interfere with nighttime sleep.',
                  ),

                  // **Healthy Sleep Habits Section**
                  Padding(
                    key: _habitsKey,
                    padding: EdgeInsets.only(left: 16, top: 8, bottom: 4),
                    child: Text(
                      'Healthy Sleep Habits',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(color: Colors.amber, thickness: 1),
                  ),
                  SizedBox(height: 8),
                  InfoCard(
                    title: 'Healthy Sleep Habits',
                    content:
                        'Healthy lifestyle choices, including physical activity, a balanced diet, and stress management, '
                        'can significantly improve sleep quality for children.',
                  ),
                  InfoCard(
                    title: 'Encourage Physical Activity',
                    content:
                        'Regular exercise during the day helps children fall asleep faster and enjoy deeper sleep. '
                        'However, avoid high-energy activities right before bed.',
                  ),
                  InfoCard(
                    title: 'Healthy Eating Habits',
                    content:
                        'Avoid sugary snacks, caffeine (found in soda, tea, and chocolate), and heavy meals close to bedtime. '
                        'A light snack, like a banana or warm milk, can be calming before bed.',
                  ),
                  InfoCard(
                    title: 'Reduce Nighttime Anxiety',
                    content:
                        'Some children experience bedtime anxiety. A comfort object, a calming bedtime story, or talking '
                        'about their day can ease their minds before sleep.',
                  ),
                  InfoCard(
                    title: 'Teach Self-Soothing Techniques',
                    content:
                        'If children wake up at night, encourage them to self-soothe rather than relying on a parent. '
                        'A favorite stuffed animal or a soft nightlight can help.',
                  ),

                  // **References**
                  Padding(
                    padding: EdgeInsets.only(left: 16, top: 8, bottom: 4),
                    child: Text(
                      'References',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(color: Colors.amber, thickness: 1),
                  ),
                  SizedBox(height: 8),
                  InfoCard(
                    title: 'References',
                    content:
                        '1. American Academy of Sleep Medicine (AASM). "Recommended Sleep Duration by Age."\n'
                        '2. National Sleep Foundation. "Healthy Sleep Tips for Children."\n'
                        '3. Centers for Disease Control and Prevention (CDC). "Children’s Sleep Guidelines."',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
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
}
