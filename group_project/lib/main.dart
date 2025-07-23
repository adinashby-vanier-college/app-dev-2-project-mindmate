import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print("✅ Firebase initialized successfully!");
  } catch (e) {
    print("❌ Firebase initialization failed: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindMate',
      home: TestFirebaseScreen(), // Temporary test screen
    );
  }
}

// Temporary test screen
class TestFirebaseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Firebase Status: ${Firebase.apps.isNotEmpty ? "✅ Connected" : "❌ Not Connected"}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("Firebase apps: ${Firebase.apps.length}");
              },
              child: Text('Check Firebase'),
            ),
          ],
        ),
      ),
    );
  }
}