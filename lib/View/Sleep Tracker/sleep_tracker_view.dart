import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elaros_gp4/Services/profile_services.dart';
import 'package:elaros_gp4/View/Sleep%20Tracker/time_input_fields.dart';
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
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime dateTime = DateTime(pickedDate.year, pickedDate.month,
            pickedDate.day, pickedTime.hour, pickedTime.minute);
        controller.text = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
      }
    }
  }

  Future<void> _saveSleepRecord() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

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
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sleep record saved successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to save: $e')));
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
    if (index != 2) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 234, 235, 235),
        title: Text("Sleep Tracker"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text("Sleepy fox"),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Selection Dropdown
            Padding(
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Profile Selection",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber),
              ),
            ),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_profiles.isEmpty)
              const Text('No profiles available')
            else
              DropdownButtonFormField<String>(
                value: _profiles
                        .any((profile) => profile['name'] == _selectedProfileId)
                    ? _selectedProfileId
                    : null,
                decoration: InputDecoration(
                  labelText: 'Select Child Profile',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amberAccent, width: 2),
                  ),
                ),
                icon: Icon(Icons.arrow_drop_down, color: Colors.amberAccent),
                dropdownColor: Colors.amber[50],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedProfileId = newValue;
                  });
                },
                items: _profiles.map<DropdownMenuItem<String>>((profile) {
                  return DropdownMenuItem<String>(
                    value: profile['name'],
                    child: Text(profile['name']),
                  );
                }).toList(),
              ),
            const Text(
              "Sleep Quality",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _qualityButton("Bad", "😫"),
                _qualityButton("Okay", "😐"),
                _qualityButton("Good", "😴"),
              ],
            ),
            const SizedBox(height: 16),
            _timeInputField("Bedtime", _bedtimeController),
            _timeInputField("Wake Up", _wakeUpController),
            const SizedBox(height: 16),

            _buildSectionHeader("Night Awakenings", _addAwakening),
            if (awakenings.isNotEmpty)
              _greyContainer(
                Column(
                  children: List.generate(
                    awakenings.length,
                    (index) => AwakeningEntry(
                      onChanged: (data) => _updateAwakening(index, data),
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

            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: "Additional Notes",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _saveSleepRecord,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color.fromARGB(255, 233, 166, 90),
        shape: const CircleBorder(),
        child: Image.asset(
          "Assets/SleepyFoxLogo512.png",
          width: 40,
          height: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
              label,
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

  Widget _timeInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      readOnly: true,
      onTap: () => _selectDateTime(controller),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.amber)),
        IconButton(icon: const Icon(Icons.add), onPressed: onAdd),
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
      color: Colors.white, // Darker grey
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );
}
