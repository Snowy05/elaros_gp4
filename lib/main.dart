import 'package:elaros_gp4/View/Dashboard/dashboard_view.dart';
import 'package:elaros_gp4/View/Login/reset_password_view.dart';
import 'package:elaros_gp4/View/Settings/Guide/guide_screen_view.dart';
import 'package:elaros_gp4/View/Settings/about_us_settings.dart';
import 'package:elaros_gp4/View/Settings/account_settings.dart';
import 'package:elaros_gp4/View/Settings/privacy_settings.dart';
import 'package:elaros_gp4/View/Settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'View/Education/education_view.dart';
import 'View/Profiles/Manage Profile/manage_pofile_view.dart';
import 'View/Profiles/Profile History/profile_history_view.dart';
import 'View/SleepStory/Stories/bear_story.dart';
import 'View/SleepStory/Stories/cat_story.dart';
import 'View/SleepStory/Stories/dog_story.dart';
import 'View/SleepStory/Stories/sleepy_story.dart';
import 'View/SleepStory/sleep_story_view.dart';
import 'firebase_options.dart';
import 'View/Login/login_view.dart';
import 'View/Register/register_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
      routes: {
        '/EducationView': (context) => const EducationView(),
        '/AboutUs': (context) => const AboutUs(),
        '/ManageProfileView': (context) => const ManageProfileView(),
        '/GuideView': (context) => const GuideScreenView(),
        '/Dashboard': (context) => const DashboardView(),
        '/WelcomeScreen': (context) => const GuideScreenView(),
        '/Register': (context) => const SignUpPage(),
        '/Login': (context) => const LoginPage(),
        '/ResetPassword': (context) => const ResetPassword(),
        '/Settings': (context) => const SettingsView(),
        '/AccountSettings': (context) => const AccountSettings(),
        '/SleepHistory': (context) => const SleepTrackingOverview(),
        '/PrivacySettings': (context) => const PrivacySettings(),
        '/SleepStoryView': (context) => const SleepStoryView(),
        '/TheSleepyStory': (context) => const SleepyStory(),
        '/SleepStoryView': (context) => const SleepStoryView(),
        '/DogStory': (context) => const DogStory(),
        '/CatStory': (context) => const CatStory(),
        '/BearStory': (context) => const BearStory(),
        // '/Notifications' : (context) => const NotificationsView(),
      },
    );
  }
}
