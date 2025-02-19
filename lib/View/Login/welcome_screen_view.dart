import 'package:elaros_gp4/Widgets/Buttons/button_styles_orange.dart';
import 'package:elaros_gp4/Widgets/Text%20Styles/text_style_black.dart';
import 'package:elaros_gp4/Widgets/Text%20Styles/text_style_light.dart';
import 'package:elaros_gp4/Widgets/Text%20Styles/welcome_text_style.dart';
import 'package:flutter/material.dart';

class WelcomeScreenView extends StatefulWidget {
  const WelcomeScreenView({super.key});

  @override
  State<WelcomeScreenView> createState() => _WelcomeScreenViewState();
}

class _WelcomeScreenViewState extends State<WelcomeScreenView> {
  int _currentIndex = 0; // Track the current card index

  List<Widget> _cards = []; // List of cards

  @override
  void initState() {
    super.initState();
    _cards = [
      _buildFirstCard(),
      _buildSecondCard(),
      _buildThirdCard(),
      _buildFourthCard(),
      _buildLastCard(),
      // Add more cards here if needed
    ];
  }

  Widget _buildFirstCard() {
    return Card(
      elevation: 3,
      color: Colors.white,
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
                    text: "Welcome To Sleepy Fox",
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: WelcomeTextStyle(
                    text:
                    "This application were designed to give you and your little ones a good night's sleep!",
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
                      _currentIndex = (_currentIndex - 1 + _cards.length) % _cards.length;
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
  Widget _buildSecondCard() {
    return Card(
      elevation: 3,
      color: Colors.white,
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
                    text: "Educational Functions",
                    textAlign: TextAlign.center,
                  ),
                ),
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
                      _currentIndex = (_currentIndex - 1 + _cards.length) % _cards.length;
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
      color: Colors.white,
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
                  padding: const EdgeInsets.only(bottom: 10),
                  child: WelcomeTextStyle(
                    text: "Analysis",
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: WelcomeTextStyle(
                    text:
                    "Want to see how they do? If they improved? You can do that by comparing their weeks of sleep. The progress is guaranteed.",
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
                      _currentIndex = (_currentIndex - 1 + _cards.length) % _cards.length;
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
      color: Colors.white,
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
                  padding: const EdgeInsets.only(bottom: 10),
                  child: WelcomeTextStyle(
                    text: "Sleep Tracker",
                    textAlign: TextAlign.center,
                  ),
                ),
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
                      _currentIndex = (_currentIndex - 1 + _cards.length) % _cards.length;
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
      color: Colors.white,
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
              'Guide',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: WelcomeTextStyle(
                    text: "Notifications",
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: WelcomeTextStyle(
                    text: "We will notify you for each time your little one has to go to bed. Of course you can silent it.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OrangeButton(text: 'Finish', onPressed: (){
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
      body: Center(
        child: Container(
          color: Colors.yellow[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              SizedBox(height: 150),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 200,
                    child: Center(
                      child: Column(
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

                height: 300,
                child: _cards[_currentIndex], // Display the current card based on the index
              ),
            ],
          ),
        ),
      ),
    );
  }
}
