import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elaros_gp4/Services/profile_services.dart';
import 'package:elaros_gp4/View/Dashboard/dashboard_view.dart';
import 'package:elaros_gp4/View/Settings/settings_view.dart';
import 'package:elaros_gp4/View/Sleep%20Tracker/time_input_fields.dart';
import 'package:elaros_gp4/Services/logout_function.dart';
import 'package:elaros_gp4/Widgets/custom_bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SleepTracking extends StatefulWidget {
  const SleepTracking({super.key});

  @override
  State<SleepTracking> createState() => _SleepTrackingState();
}

class _SleepTrackingState extends State<SleepTracking> {
  final ProfileServices _profileServices = ProfileServices();
  String? _selectedProfileId;
  String? _selectedProfileShareCode;
  List<Map<String, dynamic>> _profiles = [];

  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  Future<void> _fetchProfiles() async {
    try {
      List<Map<String, dynamic>> profiles =
          await _profileServices.fetchChildProfilesForCurrentUser();

      setState(() {
        _profiles = profiles;
        _isLoading = false;

        // Auto-select the first profile if none is selected
        if (_profiles.isNotEmpty && _selectedProfileId == null) {
          _selectedProfileId = _profiles.first['name'];
          _selectedProfileShareCode =
              _profiles[0]['sharecode']; // set sharecode for first profile
        }
      });
    } catch (error) {
      print("Failed to fetch profiles: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  final TextEditingController _bedtimeController = TextEditingController();
  final TextEditingController _wakeUpController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String? _selectedSleepQuality;
  List<Map<String, dynamic>> awakenings = [];
  List<Map<String, dynamic>> naps = [];
  bool _isLoading = true;

  Future<void> _selectDateTime(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: Colors.amber,
            hintColor: Colors.amberAccent,
            colorScheme: ColorScheme.dark(
              primary: Colors.amber,
              onPrimary: Colors.black,
              surface: Color(0xFF1A1A2E),
              onSurface: Colors.white70,
            ),
            dialogBackgroundColor: Color(0xFF121212),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              primaryColor: Colors.amber,
              hintColor: Colors.amberAccent,
              colorScheme: ColorScheme.dark(
                primary: Colors.amber,
                onPrimary: Colors.black,
                surface: Color(0xFF1A1A2E),
                onSurface: Colors.white70,
              ),
              dialogBackgroundColor: Color(0xFF121212),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        DateTime dateTime = DateTime(pickedDate.year, pickedDate.month,
            pickedDate.day, pickedTime.hour, pickedTime.minute);
        controller.text = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
      }
    }
  }

  void _showSnackbar(String message, {bool isSuccess = false}) {
    // snackbar activates for insufficient information
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _saveSleepRecord() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      // if statements to ensure bedtime,wake up time and quality is entered before saving
      if (_bedtimeController.text.trim().isEmpty) {
        _showSnackbar("Please enter your bedtime.");
        return;
      }
      if (_wakeUpController.text.trim().isEmpty) {
        _showSnackbar("Please enter your wake-up time.");
        return;
      }
      if (_selectedSleepQuality == null) {
        _showSnackbar("Please select your sleep quality.");
        return;
      }

      // Debugging: Print the naps list before filtering
      print("Before filtering: $naps");

      // Filter out empty naps (Ensure valid start and end times)
      List<Map<String, dynamic>> formattedNaps =
          naps.where((nap) => nap['start'] != '' && nap['end'] != '').toList();

      // Debugging: Print the naps list after filtering
      print("After filtering: $formattedNaps");

      // Ensure naps is not empty (Firestore does not store empty lists)
      if (formattedNaps.isEmpty) {
        formattedNaps.add({'start': 'N/A', 'end': 'N/A'}); // Placeholder data
      }

      print(_selectedProfileShareCode);
      // Save to Firestore
      await FirebaseFirestore.instance.collection('dailyTracking').add({
        'email': user.email,
        'profileId': _selectedProfileId,
        'sleepQuality': _selectedSleepQuality,
        'bedtime': _bedtimeController.text,
        'wakeUp': _wakeUpController.text,
        'awakenings': awakenings,
        'naps': formattedNaps,
        'notes': _notesController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'sharecode': _selectedProfileShareCode,
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Sleep record saved successfully'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _addAwakening() {
    setState(() {
      awakenings.add({});
    });
  }

  void _addNap() {
    setState(() {
      naps.add({'start': '', 'end': ''});
    });
  }

  void _updateAwakening(int index, Map<String, dynamic> data) {
    setState(() {
      awakenings[index] = data;
    });
  }

  void _updateNap(int index, Map<String, dynamic> data) {
    setState(() {
      print("Updating nap at index $index: $data"); // Debugging
      naps[index] = data; // Ensure correct index update
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Color.fromARGB(255, 24, 30, 58), // Dark blue background
        title: Text(
          "Sleep Tracker",
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
            image:
                AssetImage('assets/900w-xy8Cv39_lA0.png'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              // ensures content doesn't push against the bottom nav bar
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize
                      .min, // prevents unnecessary vertical expansion
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                    ),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_profiles.isEmpty)
                      const Center(
                        child: Text(
                          'No profiles available',
                          style: TextStyle(
                              color: Colors.white), // White text for dark mode
                        ),
                      )
                    else
                      DropdownButtonFormField<String>(
                        value: _profiles.any((profile) =>
                                profile['name'] == _selectedProfileId)
                            ? _selectedProfileId
                            : null,
                        decoration: InputDecoration(
                          labelText: 'Select Child Profile',
                          labelStyle: const TextStyle(
                              color: Colors.amberAccent), // Amber label
                          filled: true,
                          fillColor:
                              Color(0xFF2C3E50), // Dark grayish-blue background
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Colors.tealAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Colors.amberAccent, width: 2),
                          ),
                        ),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.amberAccent),
                        dropdownColor:
                            Color(0xFF2C3E50), // Darker dropdown background
                        style: const TextStyle(
                            color: Colors.white), // White dropdown text
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedProfileId = newValue;
                            _selectedProfileShareCode = _profiles.firstWhere(
                                (profile) =>
                                    profile['name'] == _selectedProfileId,
                                orElse: () =>
                                    {} // Return an empty map if no match is found
                                )['sharecode'];
                          });
                        },
                        items:
                            _profiles.map<DropdownMenuItem<String>>((profile) {
                          return DropdownMenuItem<String>(
                            value: profile['name'],
                            child: Text(
                              profile['name'],
                              style: const TextStyle(
                                  color:
                                      Colors.white), // White text for contrast
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 10),
                    const Text(
                      "Sleep Quality",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _qualityButton("Bad", "😫"),
                        _qualityButton("Okay", "😐"),
                        _qualityButton("Good", "😴"),
                      ],
                    ),
                    Column(
                      children: [
                        _timeInputField("Bedtime", _bedtimeController),
                        SizedBox(
                            height: 8), // Small spacing between input fields
                        _timeInputField("Wake Up", _wakeUpController),
                      ],
                    ),
                    _buildSectionHeader("Night Awakenings", _addAwakening),
                    if (awakenings.isNotEmpty)
                      AnimatedContainer(
                        duration: Duration(
                            milliseconds: 300), // Smooth transition effect
                        decoration: BoxDecoration(
                          color: Color(
                              0xFF1E2A38), // Dark navy blue for subtle contrast
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.amber[300]!,
                              width: 1), // Soft amber border
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(
                                  awakenings.isNotEmpty
                                      ? 0.5
                                      : 0.0), // Glow only if awakenings exist
                              blurRadius: awakenings.isNotEmpty ? 12 : 0,
                              spreadRadius: awakenings.isNotEmpty ? 3 : 0,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: List.generate(
                            awakenings.length,
                            (index) => AwakeningEntry(
                              onChanged: (data) =>
                                  _updateAwakening(index, data),
                            ),
                          ),
                        ),
                      ),
                    _buildSectionHeader("Naps", _addNap),
                    if (naps.isNotEmpty)
                      _greyContainer(
                        Column(
                          children: List.generate(
                            naps.length,
                            (index) => NapEntry(
                              onChanged: (data) => _updateNap(index, data),
                            ),
                          ),
                        ),
                      ),
                    TextField(
                      controller: _notesController,
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 18), // Set text color to amber
                      decoration: const InputDecoration(
                        labelText: "Additional Notes",
                        labelStyle: TextStyle(
                          color: Colors.amber,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber)),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30), // Increased padding
              child: Center(
                child: ElevatedButton(
                  onPressed: _saveSleepRecord,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: const Text(
                    "Save Sleep Record",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
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

  Widget _qualityButton(String label, String emoji) {
    bool isSelected = _selectedSleepQuality == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSleepQuality = label;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji container
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 10), // Smaller padding for a smaller container
            decoration: BoxDecoration(
              color: Colors.transparent, // Keep the container transparent
              shape: BoxShape.circle, // Circle shape
              border: isSelected
                  ? Border.all(
                      color: Colors.amber[400]!,
                      width: 2) // Amber border when selected
                  : Border.all(
                      color: Colors.transparent), // No border when not selected
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                          color: Colors.amber.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 3)
                    ] // Soft amber glow when selected
                  : [], // No glow when not selected
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: TextStyle(
                    fontSize: 40, // Smaller size for compact container
                    color: isSelected
                        ? Colors.amber[600]
                        : Colors.orange[
                            600], // Amber color when selected, orange when not
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4), // Small gap between emoji and label
          // Label container
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Colors.white
                    : Colors
                        .white70, // White text when selected, grayish-white otherwise
                fontSize: 12, // Smaller text size for the label
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white), // White text for dark mode
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.amberAccent), // Amber label
        filled: true,
        fillColor: Color(0xFF2C3E50), // Dark grayish-blue background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.tealAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.amber, width: 2),
        ),
      ),
      readOnly: true,
      onTap: () => _selectDateTime(controller),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors
                .amber, // White text for better contrast on dark background
            shadows: [
              Shadow(
                color: Colors.amber.withOpacity(0.5), // Subtle amber glow
                blurRadius: 8,
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.add, color: Colors.amber[300]), // Soft amber icon
          onPressed: onAdd,
          splashRadius: 24, // Reduce splash effect size
          tooltip: "Add $title", // Improves accessibility
        ),
      ],
    );
  }
}

class AwakeningEntry extends StatefulWidget {
  final Function(Map<String, dynamic>) onChanged;

  const AwakeningEntry({Key? key, required this.onChanged}) : super(key: key);

  @override
  _AwakeningEntryState createState() => _AwakeningEntryState();
}

class _AwakeningEntryState extends State<AwakeningEntry> {
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();
  String? selectedReason;

  void _update() {
    widget.onChanged({
      'start': startController.text,
      'end': endController.text,
      'reason': selectedReason,
    });
  }

  Widget _reasonButton(String reason, String emoji) {
    bool isSelected = selectedReason == reason;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedReason = reason;
        });
        _update();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.amber[400]
              : Colors.transparent, // Only amber when selected
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Colors.amber)
              : null, // Optional: border around the selected button
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: TextStyle(
                fontSize: 50,
                color: isSelected
                    ? Colors.white
                    : Colors.black, // Amber color for selected
              ),
            ),
            Text(
              reason,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Colors.white
                    : Colors.black, // Change label color when selected
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TimeInputField(label: "Start", controller: startController),
        TimeInputField(label: "End", controller: endController),
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12, // More spacing
          runSpacing: 12,
          children: [
            _reasonButton("Nightmare", "😨"),
            _reasonButton("Bathroom", "🚽"),
            _reasonButton("Random", "🤷"),
            _reasonButton("Energised", "⚡"),
          ],
        ),
        const Divider(),
      ],
    );
  }
}

class NapEntry extends StatefulWidget {
  final Function(Map<String, dynamic>) onChanged;

  const NapEntry({Key? key, required this.onChanged}) : super(key: key);

  @override
  _NapEntryState createState() => _NapEntryState();
}

class _NapEntryState extends State<NapEntry> {
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startController.addListener(_update);
    endController.addListener(_update);
  }

  @override
  void dispose() {
    startController.removeListener(_update);
    endController.removeListener(_update);
    startController.dispose();
    endController.dispose();
    super.dispose();
  }

  void _update() {
    widget.onChanged({
      'start': startController.text.isNotEmpty ? startController.text : 'N/A',
      'end': endController.text.isNotEmpty ? endController.text : 'N/A',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TimeInputField(label: "Start", controller: startController),
        TimeInputField(label: "End", controller: endController),
        const Divider(),
      ],
    );
  }
}

Widget _greyContainer(Widget child) {
  return Container(
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.only(top: 8), // Adds some spacing
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 245, 211, 166),
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );
}
