import 'package:elaros_gp4/Widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SleepTracking extends StatefulWidget {
  @override
  _SleepTrackingState createState() => _SleepTrackingState();
}

class _SleepTrackingState extends State<SleepTracking> {
  List<Widget> awakenings = [];
  List<Widget> naps = [];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index != 2) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _addAwakening() {
    setState(() {
      awakenings.add(AwakeningEntry());
    });
  }

  void _addNap() {
    setState(() {
      naps.add(NapEntry());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.amber,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(color: Color(0xFFFFA726)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.menu,
            color: const Color.fromARGB(255, 202, 126, 33),
          ),
          backgroundColor: const Color.fromARGB(255, 234, 235, 235),
          title: Text("Dashboard"),
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Sleep Quality",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(children: [
                      IconButton(
                          icon: Text("😫", style: TextStyle(fontSize: 50)),
                          onPressed: () {}),
                      Text("Bad")
                    ]),
                    SizedBox(width: 16),
                    Column(children: [
                      IconButton(
                          icon: Text("😐", style: TextStyle(fontSize: 50)),
                          onPressed: () {}),
                      Text("Okay")
                    ]),
                    SizedBox(width: 16),
                    Column(children: [
                      IconButton(
                          icon: Text("😴", style: TextStyle(fontSize: 50)),
                          onPressed: () {}),
                      Text("Good")
                    ]),
                  ],
                ),
                SizedBox(height: 16),
                SleepTimeEntry(title: "Bedtime"),
                SleepTimeEntry(title: "Wake up"),
                SizedBox(height: 16),
                _buildSectionHeader("Night Awakenings", _addAwakening),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(8),
                  child: Column(children: awakenings),
                ),
                SizedBox(height: 16),
                _buildSectionHeader("Naps", _addNap),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(8),
                  child: Column(children: naps),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Additional Notes",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Save Sleep Record"),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50)),
                ),
              ],
            ),
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
            "assets/SleepyFoxLogo512.png",
            width: 40,
            height: 40,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.amber)),
        IconButton(
            icon: Icon(Icons.add, color: Colors.amber), onPressed: onAdd),
      ],
    );
  }
}

class SleepTimeEntry extends StatefulWidget {
  final String title;
  SleepTimeEntry({required this.title});

  @override
  _SleepTimeEntryState createState() => _SleepTimeEntryState();
}

class _SleepTimeEntryState extends State<SleepTimeEntry> {
  TextEditingController _controller = TextEditingController();

  Future<void> _selectDateTime() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          _controller.text = DateFormat('dd/MM/yyyy HH:mm:ss').format(
            DateTime(
                picked.year, picked.month, picked.day, time.hour, time.minute),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: widget.title,
          border: OutlineInputBorder(),
        ),
        readOnly: true,
        onTap: _selectDateTime,
      ),
    );
  }
}

class AwakeningEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(children: [
              IconButton(
                  icon: Text("👻", style: TextStyle(fontSize: 40)),
                  onPressed: () {}),
              Text("Nightmare")
            ]),
            SizedBox(width: 8),
            Column(children: [
              IconButton(
                  icon: Text("🚽", style: TextStyle(fontSize: 40)),
                  onPressed: () {}),
              Text("Bathroom")
            ]),
            SizedBox(width: 8),
            Column(children: [
              IconButton(
                  icon: Text("❓", style: TextStyle(fontSize: 40)),
                  onPressed: () {}),
              Text("Random")
            ]),
            SizedBox(width: 8),
            Column(children: [
              IconButton(
                  icon: Text("⚡", style: TextStyle(fontSize: 40)),
                  onPressed: () {}),
              Text("Energised")
            ]),
          ],
        ),
        SleepTimeEntry(title: "Start"),
        SleepTimeEntry(title: "End"),
        TextField(
          decoration: InputDecoration(
            labelText: "Notes",
            border: OutlineInputBorder(),
          ),
        ),
        Divider(),
      ],
    );
  }
}

class NapEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SleepTimeEntry(title: "Start"),
        SleepTimeEntry(title: "End"),
        Divider(),
      ],
    );
  }
}
