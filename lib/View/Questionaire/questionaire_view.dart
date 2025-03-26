import 'package:elaros_gp4/Controller/improvement_plan_controller.dart';
import 'package:elaros_gp4/Controller/auth_controller.dart'; // Import the Auth Controller
import 'package:elaros_gp4/View/Sleep%20Goal/sleep_plan_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elaros_gp4/Controller/questionnaire_controller.dart';

class QuestionnaireView extends StatefulWidget {
  const QuestionnaireView({super.key});

  @override
  QuestionnaireViewState createState() => QuestionnaireViewState();
}

class QuestionnaireViewState extends State<QuestionnaireView> {
  final QuestionnaireController _controller = QuestionnaireController();
  final Map<int, Map<int, String>> _answers = {};
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = true;
  bool _hasCompletedQuestionnaire = false;
  String? _profileId;

  @override
  void initState() {
    super.initState();
    _checkIfQuestionnaireCompleted();
  }

  Future<void> _checkIfQuestionnaireCompleted() async {
    AuthController authController = AuthController();
    String? userId = authController.getCurrentUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: No user logged in. Please sign in.')),
      );
      return;
    }

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('childProfiles')
        .where('emails',
            arrayContains: FirebaseAuth.instance.currentUser?.email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot profileDoc = snapshot.docs.first;
      _profileId = profileDoc.id;
      if ((profileDoc.data()
              as Map<String, dynamic>)['hasCompletedQuestionnaire'] ==
          true) {
        setState(() {
          _hasCompletedQuestionnaire = true;
        });
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _handleSubmit() async {
    AuthController authController = AuthController();
    String? userId = authController.getCurrentUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: No user logged in. Please sign in.')),
      );
      return;
    }

    print('User answers: $_answers');

    Map<String, String> answersToStore = {};
    Map<String, String> processedAnswers = {};

    _answers.forEach((questionIndex, answers) {
      final question = _controller.questions[questionIndex];
      answers.forEach((subQuestionIndex, answer) {
        final subQuestion = question.questionText[subQuestionIndex];

        // Store answers in Firestore (original storage format)
        answersToStore[
                'Q${questionIndex + 1}_S${subQuestionIndex + 1}_ ${subQuestion.substring(0, 22)}'] =
            answer;

        // Process answers for sleep plan logic
        if (questionIndex == 0) processedAnswers["age"] = answer;
        if (questionIndex == 1) processedAnswers["sleep_duration"] = answer;
        if (questionIndex == 2 && subQuestionIndex == 0)
          processedAnswers["physical_activity"] = answer;
        if (questionIndex == 2 && subQuestionIndex == 1)
          processedAnswers["consistent_wake_time"] = answer;
        if (questionIndex == 3 && subQuestionIndex == 0)
          processedAnswers["consistent_sleep_times"] = answer;
        if (questionIndex == 3 && subQuestionIndex == 1)
          processedAnswers["morning_light_exposure"] = answer;
        if (questionIndex == 3 && subQuestionIndex == 2)
          processedAnswers["limit_bright_light"] = answer;
        if (questionIndex == 4 && subQuestionIndex == 0)
          processedAnswers["large_meal_before_bed"] = answer;
        if (questionIndex == 4 && subQuestionIndex == 1)
          processedAnswers["caffeine_consumption"] = answer;
        if (questionIndex == 4 && subQuestionIndex == 2)
          processedAnswers["sleep_friendly_snacks"] = answer;
        if (questionIndex == 5 && subQuestionIndex == 0)
          processedAnswers["outdoor_activity"] = answer;
        if (questionIndex == 6 && subQuestionIndex == 0)
          processedAnswers["relaxation_techniques"] = answer;
        if (questionIndex == 6 && subQuestionIndex == 1)
          processedAnswers["muscle_relaxation"] = answer;
        if (questionIndex == 7 && subQuestionIndex == 0)
          processedAnswers["bedroom_used_for_sleep"] = answer;
        if (questionIndex == 7 && subQuestionIndex == 1)
          processedAnswers["bedroom_distractions"] = answer;
        if (questionIndex == 7 && subQuestionIndex == 2)
          processedAnswers["darkness_preference"] = answer;
        if (questionIndex == 8 && subQuestionIndex == 0)
          processedAnswers["screen_time_before_bed"] = answer;
        if (questionIndex == 8 && subQuestionIndex == 1)
          processedAnswers["devices_to_fall_asleep"] = answer;
      });
    });

    // Generate sleep improvement plan
    Map<String, List<String>> sleepPlan = generateSleepPlan(processedAnswers);

    // Store questionnaire answers
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("questionnaire_answers")
        .add(answersToStore);

    // Store generated sleep plan
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({"sleep_plan": sleepPlan});

    // Update hasCompletedQuestionnaire field
    if (_profileId != null) {
      await FirebaseFirestore.instance
          .collection('childProfiles')
          .doc(_profileId)
          .update({"hasCompletedQuestionnaire": true});
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Answers Submitted Successfully! Sleep plan generated.')),
    );

    // Navigate to Sleep Plan View
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SleepPlan()),
    );
  }

  double _calculateProgress() {
    return (_currentPage + 1) / _controller.questions.length;
  }

  List<Widget> _buildQuestionCards() {
    return _controller.questions.asMap().entries.map((entry) {
      int index = entry.key;
      var question = entry.value;

      return SizedBox(
        height: 200,
        child: Card(
          color: Colors.white, // Apply the same color to the cards
          margin: EdgeInsets.all(16.0),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.questionTitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                ...List.generate(question.questionText.length, (qIndex) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.questionText[qIndex],
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 10),
                      ...question.answers[qIndex].map((answer) {
                        return RadioListTile<String>(
                          title: Text(answer, style: TextStyle(fontSize: 14)),
                          value: answer,
                          groupValue: _answers[index]?[qIndex],
                          onChanged: (value) {
                            setState(() {
                              _answers[index] ??= {};
                              _answers[index]![qIndex] = value!;
                            });
                          },
                        );
                      }),
                      SizedBox(height: 10),
                      if (qIndex < question.questionText.length - 1)
                        Divider(color: Colors.grey, indent: 25, endIndent: 25),
                      if (qIndex < question.questionText.length - 1)
                        SizedBox(height: 10),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 249, 232, 184),
        appBar: AppBar(
          elevation: 4,
          title: Row(
            children: [
              Image.asset('Assets/SleepyFoxLogo512.png', width: 45, height: 45),
              const SizedBox(width: 10),
              const Text('Questionnaire'),
            ],
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasCompletedQuestionnaire) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 249, 232, 184),
        appBar: AppBar(
          elevation: 4,
          title: Row(
            children: [
              Image.asset('Assets/SleepyFoxLogo512.png', width: 45, height: 45),
              const SizedBox(width: 10),
              const Text('Questionnaire'),
            ],
          ),
        ),
        body: const Center(
          child: Text(
            "You have already completed the questionnaire.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 25, 27, 53),
              Color.fromARGB(255, 28, 29, 53),
              Color.fromARGB(220, 10, 18, 43),
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 8,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: _calculateProgress()),
                  duration: Duration(milliseconds: 750),
                  builder: (context, value, _) => LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: _buildQuestionCards(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentPage < _controller.questions.length - 1) {
            _pageController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else {
            _handleSubmit();
          }
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
