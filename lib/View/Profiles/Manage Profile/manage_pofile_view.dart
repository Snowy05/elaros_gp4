import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elaros_gp4/View/Dashboard/dashboard_view.dart';
import 'package:elaros_gp4/View/Settings/settings_view.dart';
import 'package:elaros_gp4/Widgets/Buttons/button_guide_style.dart';
import 'package:elaros_gp4/Widgets/PopUp/profile_sharecode_popup.dart';
import 'package:elaros_gp4/Widgets/Text%20Styles/zaks_personal_text_style.dart';
import 'package:elaros_gp4/Widgets/custom_bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:elaros_gp4/Services/profile_services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ManageProfileView extends StatefulWidget {
  const ManageProfileView({super.key});

  @override
  State<ManageProfileView> createState() => _ManageProfileViewState();
}

class _ManageProfileViewState extends State<ManageProfileView> {
  final ProfileServices _profileServices = ProfileServices();
  List<Map<String, dynamic>> _profiles = [];
  late Future<Map<String, int>> _sleepDataFuture;
  bool _isLoading = true;

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
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

//logout function
  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, "/Login");
      print("User logged out");
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  void initState() {
    super.initState();
    _fetchProfiles();
  }

  //Profile fetch
  Future<void> _fetchProfiles() async {
    try {
      List<Map<String, dynamic>> profiles =
          await _profileServices.fetchChildProfilesForCurrentUser();
      setState(() {
        _profiles = profiles;
        _isLoading = false;
      });
    } catch (error) {
      print("Failed to fetch profiles: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchTrackingForProfile(
      String shareCode) async {
    try {
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

      // Fetch all documents with the given sharecode
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('dailyTracking')
          .where('sharecode', isEqualTo: shareCode)
          .get();

      // Filter the documents locally by the timestamp range
      List<Map<String, dynamic>> filteredData = snapshot.docs
          .where((doc) {
            final timestamp = (doc['timestamp'] as Timestamp).toDate();
            return timestamp.isAfter(firstDayOfMonth) &&
                timestamp.isBefore(lastDayOfMonth);
          })
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      print(filteredData);
      return filteredData;
    } catch (e) {
      print("Error fetching tracking data: $e");
      return [];
    }
  }

  Future<Map<String, int>> fetchWeeklySleepData(String shareCode) async {
    try {
      List<Map<String, dynamic>> allData =
          await fetchTrackingForProfile(shareCode);

      final now = DateTime.now();
      final oneWeekAgo = now.subtract(Duration(days: 7));

      Map<String, int> sleepCategories = {
        'Random': 0,
        'Nightmare': 0,
        'Bathroom': 0,
        'Energised': 0,
      };

      for (var doc in allData) {
        DateTime entryDate = (doc['timestamp'] as Timestamp).toDate();

        if (entryDate.isAfter(oneWeekAgo) && entryDate.isBefore(now)) {
          if (doc['awakenings'] != null && doc['awakenings'] is List) {
            for (var awakening in doc['awakenings']) {
              String reason = (awakening['reason'] ?? 'Random').trim();
              if (sleepCategories.containsKey(reason)) {
                sleepCategories[reason] = sleepCategories[reason]! + 1;
              } else {
                sleepCategories['Random'] = sleepCategories['Random']! + 1;
              }
            }
          }
        }
      }

      return sleepCategories;
    } catch (e) {
      print("Error fetching weekly sleep data: $e");
      return {};
    }
  }

  Future<List<Color>> getCalendarColors(String shareCode) async {
    try {
      final trackingData = await fetchTrackingForProfile(shareCode);
      final List<Color> calendarColors = List.generate(
          28, (index) => Colors.grey); // default color (grey for no data)

      // dateFormat to parse
      final dateFormat = DateFormat("dd/MM/yyyy HH:mm");

      // goes over every day to colour it
      for (var doc in trackingData) {
        final timestamp = doc['timestamp']; // firebase Timestamp
        final timestampDate =
            timestamp.toDate(); // convert to DateTime for flutter to read

        final day = timestampDate.day - 1; // zero-based index (0-27)

        // get bedtime and wakeup time from entries
        final bedtime = dateFormat
            .parse(doc['bedtime']); // parse string to DateTime using DateFormat
        final wakeUp = dateFormat
            .parse(doc['wakeUp']); // parse string to DateTime using DateFormat

        // Calculate the duration between bedtime and wakeUp
        final sleepDuration = wakeUp.difference(bedtime).inHours;

        // handle case where wakeUp is on the next day
        if (wakeUp.isBefore(bedtime)) {
          wakeUp.add(
              Duration(days: 1)); // add a day to wakeUp if it's on the next day
        }

        Color sleepColor =
            Colors.grey; // default color for the sleep duration, grey it out
        if (sleepDuration >= 8) {
          sleepColor = Colors.green; // 8+ hours: Excellent
        } else if (sleepDuration >= 6) {
          sleepColor = Colors.orange; // 6-8 hours: Could be better
        } else if (sleepDuration >= 4) {
          sleepColor = Colors.yellow; // 4-6 hours: Bad
        } else {
          sleepColor = Colors.red; // 0-4 hours: Really bad
        }

        // mark the calendar square for both days (bedtime and wakeup days)
        final bedtimeDayIndex = bedtime.day - 1;
        final wakeUpDayIndex = wakeUp.day - 1;

        // assign color to the correct calendar squares
        if (bedtimeDayIndex >= 0 && bedtimeDayIndex < 28) {
          calendarColors[bedtimeDayIndex] = sleepColor;
        }

        if (wakeUpDayIndex >= 0 &&
            wakeUpDayIndex < 28 &&
            wakeUpDayIndex != bedtimeDayIndex) {
          // no overwriting if person sleeps and wakes up same day
          calendarColors[wakeUpDayIndex] = sleepColor;
        }
      }

      return calendarColors;
    } catch (e) {
      print("Error fetching tracking data: $e");
      return List.generate(28,
          (index) => Colors.grey); // grey calender if entries cant be received
    }
  }

  //prof delete
  Future<void> _deleteProfile(String profileId) async {
    try {
      await _profileServices.deleteProfile(profileId);
      await _fetchProfiles(); // Refresh the profiles list after deletion
    } catch (error) {
      print("Failed to delete profile: $error");
    }
  }

  //Not Functional delete profile
  void _handleDeleteProfile() async {
    if (_profiles.isNotEmpty) {
      await _deleteProfile(_profiles[0]['sharecode']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int index = ModalRoute.of(context)!.settings.arguments as int;

    // Range error before profile fully loads up
    //Needs to be fixed after this sprint week. Sorry guys :(
    if (_profiles.isEmpty || index >= _profiles.length) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor:
              Color.fromARGB(255, 24, 30, 58), // Dark blue background
          title: Text(
            "View Profile",
            style: TextStyle(
              color: const Color.fromARGB(
                  255, 252, 174, 41), // Amber color for title text
            ),
          ),
          iconTheme:
              const IconThemeData(color: Color.fromARGB(255, 216, 163, 6)),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final profile = _profiles[index]; // Index of selected profile
    print(profile["sharecode"]);
    fetchTrackingForProfile(profile["sharecode"]);
    _sleepDataFuture = fetchWeeklySleepData(profile["sharecode"]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Color.fromARGB(255, 24, 30, 58), // Dark blue background
        title: Text(
          "View Profile",
          style: TextStyle(
            color: const Color.fromARGB(
                255, 252, 174, 41), // Amber color for title text
          ),
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 216, 163, 6)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wp11179213.png'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // TOP PROFILE SECTION
                    Padding(
                      padding: const EdgeInsets.all(8.2),
                      child: Card(
                        color: const Color.fromARGB(103, 12, 30, 53),
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            // PROFILE PICTURE
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Image.asset(
                                  "assets/SleepyFoxLogo512.png",
                                  width: 100,
                                  height: 100,
                                ),
                                _isLoading
                                    ? CircularProgressIndicator()
                                    : Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              profile["name"],
                                              style: TextStyle(
                                                fontSize: 42,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber[300],
                                              ),
                                            ),
                                            Container(height: 0),
                                            Text(
                                              "Age: ${profile['age'].toString()}",
                                              style: TextStyle(
                                                fontSize: 42,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber[300],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Decorative Bar
                    SizedBox(
                      height: 20,
                    ),

                    // PROFILE SLEEP ANALYSIS

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          //pie chart card
                          FutureBuilder<Map<String, int>>(
                            future: _sleepDataFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error loading sleep data');
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Text('No sleep data available');
                              }

                              final sleepData = snapshot.data!;

                              // awakening reasons
                              final awakeningCategories = [
                                'Random',
                                'Nightmare',
                                'Bathroom',
                                'Energised'
                              ];

                              // check if all == 0
                              final hasAwakenings = sleepData.entries
                                  .where((entry) =>
                                      awakeningCategories.contains(entry.key))
                                  .any((entry) => entry.value > 0);

                              return Card(
                                color: const Color.fromARGB(103, 12, 30, 53),
                                elevation: 5,
                                margin: EdgeInsets.all(5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  width: 300,
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Awakenings\nthis week',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.amber[300]),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        height: 200,
                                        child: SfCircularChart(
                                          annotations: <CircularChartAnnotation>[
                                            CircularChartAnnotation(
                                              widget: Text(
                                                '',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          ],
                                          series: <DoughnutSeries<
                                              Map<String, dynamic>, String>>[
                                            DoughnutSeries<Map<String, dynamic>,
                                                String>(
                                              dataSource: hasAwakenings
                                                  ? sleepData.entries
                                                      .where((entry) =>
                                                          awakeningCategories
                                                              .contains(
                                                                  entry.key) &&
                                                          entry.value > 0)
                                                      .map((entry) => {
                                                            'label': entry.key,
                                                            'value':
                                                                entry.value,
                                                            'color':
                                                                _getCategoryColor(
                                                                    entry.key),
                                                          })
                                                      .toList()
                                                  : [
                                                      {
                                                        'label':
                                                            'No Awakenings',
                                                        'value': 1,
                                                        'color': Colors.grey
                                                      },
                                                    ],
                                              xValueMapper: (data, _) =>
                                                  data['label'],
                                              yValueMapper: (data, _) =>
                                                  data['value'],
                                              pointColorMapper: (data, _) =>
                                                  data['color'],
                                              dataLabelSettings:
                                                  DataLabelSettings(
                                                isVisible: true,
                                                labelPosition:
                                                    ChartDataLabelPosition
                                                        .inside,
                                              ),
                                              animationDuration: 1500,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              _buildLegendRow('Random', '🔵'),
                                              _buildLegendRow(
                                                  '  Nightmare', '🔴'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              _buildLegendRow('Bathroom', '🟠'),
                                              _buildLegendRow(
                                                  '  Energised', '🟢'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          //Calendar Card
                          Card(
                            color: const Color.fromARGB(103, 12, 30, 53),
                            elevation: 5,
                            margin: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              width: 350,
                              padding: EdgeInsets.all(15),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sleep Calender',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber[300]),
                                  ),
                                  SizedBox(height: 50),
                                  FutureBuilder<List<Color>>(
                                    future: getCalendarColors(profile[
                                        "sharecode"]), // Call the function here
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator(); // show loading spinner while data is being fetched
                                      }

                                      if (snapshot.hasError) {
                                        return Center(
                                            child: Text('Error fetching data'));
                                      }

                                      if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return Center(
                                            child: Text(
                                                'No data available for this month'));
                                      }

                                      List<Color> calendarColors =
                                          snapshot.data!;

                                      return SizedBox(
                                        height: 200,
                                        child: GridView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 7,
                                            mainAxisSpacing: 4,
                                            crossAxisSpacing: 4,
                                          ),
                                          itemCount: 28,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: calendarColors[
                                                    index], // Use color from the data
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${index + 1}',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Excellent: 🟢',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber[300]),
                                          ),
                                          SizedBox(width: 20),
                                          Text(
                                            'Could be better: 🟠',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber[300]),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Bad: 🟡',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber[300]),
                                          ),
                                          SizedBox(width: 20),
                                          Text(
                                            'Really Bad: 🔴',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber[300]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            GuideButton(
                              //Share Profile Button
                              text: 'Share Profile',
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ProfilePopUp(
                                          content: profile['sharecode'],
                                          title:
                                              'Share Code'); //PopUp Dialog can be found in widgets/PopUp
                                    });
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
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
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Random':
        return Colors.blue;
      case 'Nightmare':
        return Colors.red;
      case 'Bathroom':
        return Colors.orange;
      case 'Energised':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildLegendRow(String label, String emoji) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label: $emoji',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 255, 204, 52)),
          ),
        ],
      ),
    );
  }
}
