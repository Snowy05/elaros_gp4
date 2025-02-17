import 'package:elaros_gp4/Widgets/button_styles_orange.dart';
import 'package:elaros_gp4/Widgets/text_style_black.dart';
import 'package:elaros_gp4/Widgets/text_style_light.dart';
import 'package:flutter/material.dart';

class WelcomeScreenView extends StatefulWidget {
  const WelcomeScreenView({super.key});

  @override
  State<WelcomeScreenView> createState() => _WelcomeScreenViewState();
}

class _WelcomeScreenViewState extends State<WelcomeScreenView> {
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
              Container(
                child: Column(
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
              ),
              SizedBox(height: 20),
              Container(
                height: 300,
                child: Card(
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
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(height: 20),
                        Container(
                          child: Text('Guide example'),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OrangeButton(onPressed: () {}, text: 'Back',),
                            OrangeButton(text: "Next", onPressed: (){},),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

