import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elaros_gp4/Services/profile_services.dart';
import 'package:elaros_gp4/View/Dashboard/dashboard_view.dart';
import 'package:elaros_gp4/View/Settings/settings_view.dart';
import 'package:elaros_gp4/Services/logout_function.dart';
import 'package:elaros_gp4/Widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for parsing custom date formats i had to use this package

class SleepTrackingOverview extends StatefulWidget {
  const SleepTrackingOverview({super.key});

  @override
  State<SleepTrackingOverview> createState() => _SleepTrackingOverviewState();
}

class _SleepTrackingOverviewState extends State<SleepTrackingOverview> {
  final ProfileServices _profileServices = ProfileServices();
  List<Map<String, dynamic>> _profiles = [];
  List<Map<String, dynamic>> _allRecords =
      []; // Holds sleep records based on filter
  bool _isLoading = true;
  String? _selectedProfile; // Currently selected child profile
  String? _selectedProfileShareCode;
  String _selectedFilter = "This Week";

  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  // Fetch profiles from our database and update the ui
  Future<void> _fetchProfiles() async {
    try {
      final profiles =
          await _profileServices.fetchChildProfilesForCurrentUser();
      setState(() {
        _profiles = profiles;
        _isLoading = false;

        // Auto-select the first profile and fetch its records
        if (_profiles.isNotEmpty) {
          _selectedProfile = _profiles.first['name'];
          _selectedProfileShareCode = _profiles.first['sharecode'];
          _fetchAllRecords(
              _selectedProfileShareCode!); // Fetch data for the first profile
        }
      });
    } catch (error) {
      print("Failed to fetch profiles: $error");
      setState(() {
        _isLoading = false;
      });
    }
  } // get sleep records for a selected profile with the active filter.

  Future<void> _fetchAllRecords(String profileId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final now = DateTime.now();

      // week filter logic
      DateTime? startOfWeek;
      DateTime? endOfWeek;
      if (_selectedFilter == "This Week") {
        startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Monday
        endOfWeek = startOfWeek.add(const Duration(days: 7)); // End of week
      } else if (_selectedFilter == "Last Week") {
        startOfWeek =
            now.subtract(Duration(days: now.weekday + 6)); // Previous Monday
        endOfWeek =
            startOfWeek.add(const Duration(days: 7)); // End of last week
      }

      final sleepDateFormat =
          DateFormat("dd/MM/yyyy HH:mm"); // Matches wakeUp format

      final snapshot = await FirebaseFirestore.instance
          .collection('dailyTracking')
          .where('sharecode', isEqualTo: profileId)
          .get();

      final records = snapshot.docs
          .map((doc) {
            final data = doc.data();
            data['timestamp'] = (data['timestamp'] as Timestamp)
                .toDate(); // getting the timestamp from database, and parse it

            try {
              final wakeUpTime =
                  sleepDateFormat.parse(data['wakeUp']); // Parse wake-up time
              if (_selectedFilter == "All" ||
                  (wakeUpTime.isAfter(startOfWeek!) &&
                      wakeUpTime.isBefore(endOfWeek!))) {
                return data;
              }
            } catch (e) {
              print("Error parsing wakeUp for doc ${doc.id}: $e");
            }
            return null;
          })
          .where((record) => record != null)
          .toList();

      setState(() {
        _allRecords = records.cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    } catch (error) {
      print("Failed to fetch records: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 4) {
      logout(context); // Log out
    } else if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardView()),
      ); // Go to Dashboard
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SettingsView()),
      ); // Go to Settings
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
        backgroundColor: Color.fromARGB(255, 24, 30, 58), // Dark blue background
        title: Text(
          "Sleep History",
          style: TextStyle(
            color: Color.fromARGB(255, 249, 171, 37), // Amber color for title text
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 216, 163, 6), // Color for icons, including the PopupMenuButton icon
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String filter) {
              setState(() {
                _selectedFilter = filter; // Update the filter
              });
              // Fetch data immediately with the current profile share code
              if (_selectedProfileShareCode != null) {
                _fetchAllRecords(_selectedProfileShareCode!);
              } else {
                print("No profile selected to fetch records.");
              }
            },
            icon: Icon(
              Icons.filter_alt,
              color: Color.fromARGB(255, 216, 163, 6), // Explicitly set the icon color
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: "All",
                child: Text("All"), // Show all records
              ),
              const PopupMenuItem<String>(
                value: "This Week",
                child: Text("This Week"), // Filter for this week's records
              ),
              const PopupMenuItem<String>(
                value: "Last Week",
                child: Text("Last Week"), // Filter for last week's records
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                _selectedFilter,
                style: TextStyle(
                  color: Color.fromARGB(255, 249, 171, 37), // Amber color for the filter text
                ),
              ), // filter in use
            ),
          ),
        ],
      ),      body: _isLoading
          ? Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/900w-xy8Cv39_lA0.png'), // Background image
                  fit: BoxFit.cover,
                ),
              ),
              child: const Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.amberAccent,
              )))
          : _profiles.isEmpty
              ? const Center(child: Text('No profiles available'))
              : Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/900w-xy8Cv39_lA0.png'), // Background image
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      // drop for profile selection
                      DropdownButton<String>(
                        value: _selectedProfile,
                        hint: const Text("Select a Profile"),
                        items:
                            _profiles.map<DropdownMenuItem<String>>((profile) {
                          return DropdownMenuItem<String>(
                            value: profile['name'],
                            child: Text(
                              profile['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedProfile =
                                  newValue; // Update selected profile
                              _selectedProfileShareCode = _profiles.firstWhere(
                                (profile) =>
                                    profile['name'] == _selectedProfile,
                                orElse: () => {"sharecode": null},
                              )['sharecode'];
                            });

                            // Fetch records immediately for the newly selected profile
                            if (_selectedProfileShareCode != null) {
                              _fetchAllRecords(_selectedProfileShareCode!);
                            }
                          }
                        },
                      ),
                      Expanded(
                        child: _allRecords.isEmpty
                            ? const Center(child: Text('No records found'))
                            : ListView.builder(
                                itemCount: _allRecords.length,
                                itemBuilder: (context, index) {
                                  final record = _allRecords[index];

                                  //date time formatting
                                  final dateFormat =
                                      DateFormat("dd/MM/yyyy HH:mm");
                                  final timeFormat = DateFormat("HH:mm");
                                  DateTime? bedtime;
                                  DateTime? wakeUp;
                                  String bedtimeTime = "N/A";
                                  String wakeUpTime = "N/A";
                                  String date = "N/A";

                                  try {
                                    if (record['bedtime'] != null) {
                                      bedtime =
                                          dateFormat.parse(record['bedtime']);
                                      bedtimeTime = timeFormat.format(bedtime);
                                      date = DateFormat("dd/MM/yyyy")
                                          .format(bedtime);
                                    }
                                    if (record['wakeUp'] != null) {
                                      wakeUp =
                                          dateFormat.parse(record['wakeUp']);
                                      wakeUpTime = timeFormat.format(wakeUp);
                                    }
                                  } catch (e) {
                                    print("Error parsing times: $e");
                                  }

                                  //quality text and emoji
                                  String quality = "N/A";
                                  String emoji = "❓";
                                  if (record['sleepQuality'] != null) {
                                    final qualityValue = record['sleepQuality'];
                                    if (qualityValue == "Good") {
                                      quality = "Good";
                                      emoji = "😴";
                                    } else if (qualityValue == "Okay") {
                                      quality = "Okay";
                                      emoji = "😑";
                                    } else if (qualityValue == "Bad") {
                                      quality = "Bad";
                                      emoji = "😖";
                                    }
                                  }

                                  return Card(
                                    elevation: 12,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 23, 28, 55),
                                            Colors.blueGrey.shade700
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Date displayed at the top
                                            Text(
                                              'Date: $date',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber,
                                              ),
                                            ),
                                            const SizedBox(
                                                height:
                                                    8), // Spacing between date and columns
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Left Column: Bedtime and Awakenings
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Bedtime: $bedtimeTime',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Awakenings: ${record['awakenings']?.length ?? 0}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // Right Column: Wake-Up, Naps, and Quality
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Wake Up: $wakeUpTime',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Naps: ${record['naps']?.length ?? 0}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Quality: $quality $emoji',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                                height:
                                                    8), // Spacing before notes
                                            // Notes displayed at the bottom
                                            Text(
                                              'Notes: ${record['notes'] ?? 'N/A'}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.amber,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      )
                    ],
                  ),
                ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
