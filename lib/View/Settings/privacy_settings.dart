import 'package:elaros_gp4/View/Dashboard/dashboard_view.dart';
import 'package:elaros_gp4/View/Sleep%20Tracker/sleep_tracker_view.dart';
import 'package:elaros_gp4/Widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

bool allowAnalytics = false;
bool allowPerformanceMetrics = false;

class PrivacySettings extends StatefulWidget {
  const PrivacySettings({super.key});

  @override
  State<PrivacySettings> createState() => _PrivacySettingsState();
}

class _PrivacySettingsState extends State<PrivacySettings> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
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
    }
  }

  Widget _buildToggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.amber,
        ),
      ],
    );
  }

  Widget _buildPrivacyPolicyCard() {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      shadowColor: Colors.black.withOpacity(0.4),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(220, 10, 18, 43),
              Color.fromARGB(255, 28, 29, 53),
              Color.fromARGB(255, 25, 27, 53),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Privacy Policy",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
            const Divider(color: Colors.amber, height: 30),
            const Text(
              "Read our Privacy Policy to understand how your data is used.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text("Privacy Policy", style: TextStyle(color: Colors.amber)),
                      content: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: double.maxFinite,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              '''
This Privacy Notice for Elaros ('we', 'us', or 'our'), describes how and why we might access, collect, store, use, and/or share your personal information when you use our services ('Services'), including:

• Download and use our mobile application (Sleepy Fox), or any other application that links to this Privacy Notice  
• Engage with us in other related ways, including marketing or events

We aim to protect your personal information through a system of organisational and technical security measures. We do not process sensitive personal information and we don’t collect data from third parties.

You have the right to access, review, or delete your personal data. You can also email us at hello@elaros.com if you have questions.

For more, see: how we use, share, and store your data.

Last updated: March 26, 2025
                            ''',
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Close", style: TextStyle(color: Colors.amber)),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text("View Privacy Policy"),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Color.fromARGB(255, 24, 30, 58), // Dark blue background
        title: Text(
          "Privacy",
          style: TextStyle(
            color: const Color.fromARGB(
                255, 252, 174, 41), // Amber color for title text
          ),
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 216, 163, 6)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(220, 10, 18, 43),
              Color.fromARGB(255, 28, 29, 53),
              Color.fromARGB(255, 25, 27, 53),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),

                          // Manage Data Collection Card
                          Card(
                            elevation: 12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            shadowColor: Colors.black.withOpacity(0.4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 24, horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromARGB(220, 10, 18, 43),
                                    Color.fromARGB(255, 28, 29, 53),
                                    Color.fromARGB(255, 25, 27, 53),
                                  ],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Center(
                                    child: Text(
                                      "Manage Data Collection",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                      color: Colors.amber, height: 30),
                                  _buildToggleTile(
                                    title: "Allow Usage Analytics",
                                    subtitle:
                                        "Help us improve by sending anonymous usage data.",
                                    value: allowAnalytics,
                                    onChanged: (newValue) {
                                      setState(() {
                                        allowAnalytics = newValue;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  _buildToggleTile(
                                    title: "App Performance Metrics",
                                    subtitle:
                                        "Let us monitor performance for crash analysis.",
                                    value: allowPerformanceMetrics,
                                    onChanged: (newValue) {
                                      setState(() {
                                        allowPerformanceMetrics = newValue;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          _buildPrivacyPolicyCard(),

                          const Spacer(), // This ensures that content is pushed to the top if screen is tall
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
