import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.menu,
            color: const Color.fromARGB(255, 202, 126, 33)
            ),
          backgroundColor: const Color.fromARGB(255, 234, 235, 235),
          title: Text("Dashboard"),
          actions: [
            Padding(
              padding: 
                EdgeInsets.only(right: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Sleepy fox"),
                )
            )
          ],
        ),
        body: Column(
          children: [
            // SLIDING FIRST PART OF DASHBOARD
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.white, // White background
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Box 1
                    Column(
                      children: [
                        Container(
                          width: 100,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.grey[300], // Light grey box
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 8), // Spacing
                        const Text(
                          "Label 1",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20), // Space between boxes
        // Box 2
                    Column(
                      children: [
                        Container(
                          width: 100,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.grey[300], // Light grey box
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 8), // Spacing
                        const Text(
                          "Label 2",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20), // Space between boxes
                    // Box 3
                    Column(
                      children: [
                        Container(
                          width: 100,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.grey[300], // Light grey box
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 8), // Spacing
                        const Text(
                          "Label 3",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // SLEEPYFOX FEATURES PART
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.red,
              ),
            ),
            // SLEEP ANALYSIS PART  
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.blue,
              ),
            ),
            // LEARN MORE , START TRACKING
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.red,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "home",
            ),
          ],
        ),
      ),
    );
  }
}

