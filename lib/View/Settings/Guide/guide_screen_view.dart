import 'package:elaros_gp4/View/Settings/Guide/guide_bulletlist.dart';
import 'package:elaros_gp4/Widgets/Buttons/button_styles_orange.dart';
import 'package:elaros_gp4/Widgets/Text%20Styles/text_style_black.dart';
import 'package:elaros_gp4/Widgets/Text%20Styles/text_style_light.dart';
import 'package:elaros_gp4/Widgets/Text%20Styles/welcome_text_style.dart';
import 'package:flutter/material.dart';

class GuideScreenView extends StatefulWidget {
  const GuideScreenView({super.key});

  @override
  State<GuideScreenView> createState() => _GuideScreenViewState();
}

class _GuideScreenViewState extends State<GuideScreenView> {
  int _currentIndex = 0; // Track the current card index

  List<Widget> _cards = []; // List of cards

  @override
  void initState() {
    super.initState();
    _cards = [
      _buildFirstCard(),
      _buildSecondCard(),
      _buildThirdCard(),
      _buildAnalysis2Card(),
      _buildFourthCard(),
      _buildSleepTrackCard(),
      _buildLastCard(),
      _buildBedtimeCard(),
      _buildFifthCard(),
      // Add more cards here if needed
    ];
  }

  Widget _buildFirstCard() {
    return Card(
      elevation: 3,
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Quick Guide',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: WelcomeTextStyle(
                    text:
                        "This application were designed to give you and your little ones a good night's sleep! Follow through"
                        " with this quick guide to explore how you will be able to achieve it.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OrangeButton(
                  text: "Next",
                  onPressed: () {
                    setState(() {
                      _currentIndex = (_currentIndex + 1) % _cards.length;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondCard() {
    return Card(
      elevation: 3,
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Educational Functions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 20),
                //   child: WelcomeTextStyle(
                //     text: "Educational Functions",
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: WelcomeTextStyle(
                    text:
                        "We have gathered all the information that you need! If you feel overwhelmed by all "
                        "the information, you can always take our assessment which will give you the ones you need!",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OrangeButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex =
                          (_currentIndex - 1 + _cards.length) % _cards.length;
                    });
                  },
                  text: 'Back',
                ),
                OrangeButton(
                  text: "Next",
                  onPressed: () {
                    setState(() {
                      _currentIndex = (_currentIndex + 1) % _cards.length;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThirdCard() {
    return Card(
      elevation: 3,
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Analysis',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 10),
                //   child: WelcomeTextStyle(
                //     text: "Analysis",
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: WelcomeTextStyle(
                    text:
                        "Want to see how they do? If they improved? You can do that by comparing their weeks of sleep."
                        "You can find this information in your child's profile. The progress is guaranteed.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OrangeButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex =
                          (_currentIndex - 1 + _cards.length) % _cards.length;
                    });
                  },
                  text: 'Back',
                ),
                OrangeButton(
                  text: "Next",
                  onPressed: () {
                    setState(() {
                      _currentIndex = (_currentIndex + 1) % _cards.length;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBedtimeCard() {
    return Card(
      elevation: 3,
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Bedtime Stories',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 10),
                //   child: WelcomeTextStyle(
                //     text: "Sleep Tracker",
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: WelcomeTextStyle(
                    text:
                        "If you tap on the Bedtime Stories, you can choose and read stories together to prepare for a good night sleep. There are a wide selection of stories to choose from",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OrangeButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex =
                          (_currentIndex - 1 + _cards.length) % _cards.length;
                    });
                  },
                  text: 'Back',
                ),
                OrangeButton(
                  text: "Next",
                  onPressed: () {
                    setState(() {
                      _currentIndex = (_currentIndex + 1) % _cards.length;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysis2Card() {
    return Card(
      elevation: 3,
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Analysis',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 10),
                //   child: WelcomeTextStyle(
                //     text: "Analysis",
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: WelcomeTextStyle(
                    text:
                        "You will be able to see how they progress through pie chart, top reasons of awakenings and all kinds of statistics which makes it easier to understand"
                        " how your little ones are doing.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OrangeButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex =
                          (_currentIndex - 1 + _cards.length) % _cards.length;
                    });
                  },
                  text: 'Back',
                ),
                OrangeButton(
                  text: "Next",
                  onPressed: () {
                    setState(() {
                      _currentIndex = (_currentIndex + 1) % _cards.length;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFourthCard() {
    return Card(
      elevation: 3,
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Sleep Tracker',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 10),
                //   child: WelcomeTextStyle(
                //     text: "Sleep Tracker",
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: WelcomeTextStyle(
                    text:
                        "Track your little ones sleep. You can even record how many times they woke up, or how long they sleep for!",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OrangeButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex =
                          (_currentIndex - 1 + _cards.length) % _cards.length;
                    });
                  },
                  text: 'Back',
                ),
                OrangeButton(
                  text: "Next",
                  onPressed: () {
                    setState(() {
                      _currentIndex = (_currentIndex + 1) % _cards.length;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepTrackCard() {
    return Card(
      elevation: 3,
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Sleep Tracker',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 10),
                //   child: WelcomeTextStyle(
                //     text: "Sleep Tracker",
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: BulletPointList(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OrangeButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex =
                          (_currentIndex - 1 + _cards.length) % _cards.length;
                    });
                  },
                  text: 'Back',
                ),
                OrangeButton(
                  text: "Next",
                  onPressed: () {
                    setState(() {
                      _currentIndex = (_currentIndex + 1) % _cards.length;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFifthCard() {
    return Card(
      elevation: 3,
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Sleep Tracker',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 10),
                //   child: WelcomeTextStyle(
                //     text: "Sleep Tracker",
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: WelcomeTextStyle(
                    text:
                        "Track your little ones sleep. You can even record how many times they woke up, or how long they slep for!",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OrangeButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex =
                          (_currentIndex - 1 + _cards.length) % _cards.length;
                    });
                  },
                  text: 'Back',
                ),
                OrangeButton(
                  text: "Next",
                  onPressed: () {
                    setState(() {
                      _currentIndex = (_currentIndex + 1) % _cards.length;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastCard() {
    return Card(
      elevation: 3,
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Relaxing Music',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 10),
                //   child: WelcomeTextStyle(
                //     text: "Notifications",
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: WelcomeTextStyle(
                    text:
                        "The application has a default relaxation music which plays in the background. Of course you can silent it just right in the settings.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OrangeButton(
                    text: 'Finish',
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/Dashboard');
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/moonbackground.png'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 100),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 500,
                                  height: 200,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        StrokeTextDark(
                                          text: "Sleepy",
                                          textStyle: TextStyle(fontSize: 70),
                                        ),
                                        StrokeTextLight(
                                          text: "Fox",
                                          textStyle: TextStyle(fontSize: 70),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              constraints: BoxConstraints(
                                minHeight: 0,
                                maxHeight: double.infinity,
                              ),
                              child: _cards[
                                  _currentIndex], // Display the current card based on the index
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      //progression bar
                      width: 400,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: LinearProgressIndicator(
                          value: (_currentIndex + 1) / _cards.length,
                          color: Colors.orange,
                          backgroundColor: Colors.grey[300],
                          minHeight: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
