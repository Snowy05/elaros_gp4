import 'package:elaros_gp4/Widgets/Text%20Styles/welcome_text_style.dart';
import 'package:flutter/material.dart';

class BulletPointList extends StatelessWidget {
  final List<String> items = [
    "Press on \"Sleep\" button and select Sleep Tracker.",
    "Then enter the start and end time of the sleep.",
    "You can also record activities like waking up middle of the night or even snacks.",
    "If they need to take a nap, you can record that as well."
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeTextStyle(text: "🦊 ",style: TextStyle(fontSize: 30),),
              Expanded(child: WelcomeTextStyle(text: item,),
              )// Item text
            ],
          );
        }).toList(),
      ),
    );
  }
}