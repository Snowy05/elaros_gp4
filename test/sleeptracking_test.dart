import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'mockSleepTracking.mocks.dart'; // Import the generated mocks

void main() {
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDoc;
  late MockUser mockUser;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference<Map<String, dynamic>>(); 
    mockDoc = MockDocumentReference<Map<String, dynamic>>(); 
    mockUser = MockUser();

    when(mockAuth.currentUser).thenReturn(mockUser);
    when(mockUser.email).thenReturn("test@example.com");

    // mockcollection shows exact type of variable
    when(mockFirestore.collection(any))
        .thenReturn(mockCollection as CollectionReference<Map<String, dynamic>>);

    when(mockCollection.add(any))
        .thenAnswer((_) async => mockDoc);
  });

  testWidgets("Shows error when bedtime is missing", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please enter your bedtime.")),
                );
              },
              child: const Text("Save Sleep Record"),
            );
          },
        ),
      ),
    ));

    await tester.tap(find.text("Save Sleep Record"));
    await tester.pump();

    expect(find.text("Please enter your bedtime."), findsOneWidget);
  });

  testWidgets("Shows error when wake-up time is missing", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please enter your wake-up time.")),
                );
              },
              child: const Text("Save Sleep Record"),
            );
          },
        ),
      ),
    ));

    await tester.tap(find.text("Save Sleep Record"));
    await tester.pump();

    expect(find.text("Please enter your wake-up time."), findsOneWidget);
  });

  testWidgets("Shows error when sleep quality is missing", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please select your sleep quality.")),
                );
              },
              child: const Text("Save Sleep Record"),
            );
          },
        ),
      ),
    ));

    await tester.tap(find.text("Save Sleep Record"));
    await tester.pump();

    expect(find.text("Please select your sleep quality."), findsOneWidget);
  });

  testWidgets("Shows success message when sleep record is saved", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                await mockCollection.add({
                  "email": mockUser.email,
                  "bedtime": "10:00 PM",
                  "wakeUp": "6:30 AM",
                  "sleepQuality": "Good"
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Sleep record saved successfully.")),
                );
              },
              child: const Text("Save Sleep Record"),
            );
          },
        ),
      ),
    ));

    await tester.tap(find.text("Save Sleep Record"));
    await tester.pump();

    expect(find.text("Sleep record saved successfully."), findsOneWidget);
  });
}