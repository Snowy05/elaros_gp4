import 'package:flutter/material.dart';

class SettingsFeatureCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailingContent;

  const SettingsFeatureCard({
    super.key,
    required this.title,
    this.subtitle,
    this.trailingContent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      shadowColor: Colors.black.withOpacity(0.4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 23, 28, 55),
              Colors.blueGrey.shade700,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        width: double.infinity,
        height: 180,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text side
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Custom content (optional toggle, icon, etc)
              if (trailingContent != null)
                SizedBox(width: 20),
              if (trailingContent != null)
                trailingContent!,
            ],
          ),
        ),
      ),
    );
  }
}
