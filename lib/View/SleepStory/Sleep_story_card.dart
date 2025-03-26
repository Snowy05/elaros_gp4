import 'package:flutter/material.dart';

class SleepStoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String content;
  final String next;

  const SleepStoryCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.content,
    required this.next,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 700,
      child: Card(
        color: const Color.fromARGB(162, 23, 29, 62),
        margin: EdgeInsets.all(16.0),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              SizedBox(height: 10),
              Text(
                content,
                style: TextStyle(fontSize: 20, color: Colors.amber),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Text(
                next,
                style: TextStyle(fontSize: 14, color: Colors.amber),
              ),

            ],
          ),
        ),
      ),
    );
  }
}