import 'package:flutter/material.dart';

class InfoContainer extends StatelessWidget {
  final String title;
  final String subtitle;

  const InfoContainer({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 250,
      color: Colors.grey,
      child: Column(
        children: [
          const Spacer(),
          Container(
            color: Colors.white70,
            height: 50,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Expanded(
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

