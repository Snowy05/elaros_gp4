import 'package:elaros_gp4/View/Dashboard/dashboard_view.dart';
import 'package:elaros_gp4/View/Settings/settings_view.dart';
import 'package:elaros_gp4/View/Sleep%20Tracker/sleep_tracker_view.dart';
import 'package:elaros_gp4/Widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SleepPlan extends StatefulWidget {
  const SleepPlan({super.key});

  @override
  State<SleepPlan> createState() => _SleepPlanState();
}

class _SleepPlanState extends State<SleepPlan> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, List<String>>?> _fetchSleepPlan() async {
    print("Fetching sleep plan..."); // Debug message
    User? user = _auth.currentUser;
    if (user == null) {
      print("No user logged in."); // Debug message
      return null;
    }

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!snapshot.exists ||
          !(snapshot.data() as Map<String, dynamic>)
              .containsKey("sleep_plan")) {
        print("No sleep plan found in Firestore."); // Debug message
        return null;
      }

      // Log the raw data for debugging
      print("Raw sleep plan data: ${snapshot["sleep_plan"]}");

      // Deserialize the sleep plan
      Map<String, dynamic> rawSleepPlan =
          (snapshot.data() as Map<String, dynamic>)["sleep_plan"];
      return rawSleepPlan.map((key, value) {
        return MapEntry(key, List<String>.from(value));
      });
    } catch (e) {
      print("Error fetching sleep plan: $e");
      return null;
    }
  }

  int _selectedIndex = 0;

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
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SettingsView()),
      );
    } else if (index != 2) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.amber.shade500,
        ),
        backgroundColor: Color.fromARGB(255, 24, 30, 58),
        title: Text("Personalised Sleep Plan",
            style: TextStyle(
              color: const Color.fromARGB(
                  255, 252, 174, 41), // Amber color for title text
            )),
      ),
      backgroundColor:
          Colors.transparent, // Ensure the Scaffold background is transparent
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color.fromARGB(255, 25, 27, 53),
                  Color.fromARGB(255, 28, 29, 53),
                  Color.fromARGB(255, 32, 52, 111),
                ],
              ),
            ),
          ),
          // Scrollable content
          FutureBuilder<Map<String, List<String>>?>(
            future: _fetchSleepPlan(),
            builder: (context, snapshot) {
              print(
                  "FutureBuilder state: ${snapshot.connectionState}"); // Debug message

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                print(
                    "FutureBuilder error: ${snapshot.error}"); // Debug message
                return Center(
                  child: Text(
                    "Error fetching sleep plan: ${snapshot.error}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data == null) {
                print("FutureBuilder: No data available."); // Debug message
                return const Center(
                  child: Text(
                    "No sleep plan available. Please complete the questionnaire first.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              }

              Map<String, List<String>> sleepPlan = snapshot.data!;
              print("FutureBuilder: Data received."); // Debug message

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: sleepPlan.entries.map((entry) {
                      String category = entry.key;
                      List<String> recommendations = entry.value;

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: const Color.fromARGB(162, 23, 29,
                            62), // Match QuestionnaireView card color
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 25, 27, 53),
                                Color.fromARGB(255, 28, 29, 53),
                                Color.fromARGB(255, 32, 52, 111),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors
                                      .amber, // Match QuestionnaireView text color
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (recommendations.isEmpty) ...[
                                const Text(
                                  "No Recommendations for this Category. Well Done!",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white70, // Subtext color
                                  ),
                                ),
                              ] else ...[
                                ...recommendations.map((recommendation) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      recommendation,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white, // Match text color
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
