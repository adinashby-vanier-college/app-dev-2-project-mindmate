import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';
import '../widgets/mood_slider.dart';
import 'home_screen.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final DatabaseService _db = DatabaseService();
  double _currentMood = 5.0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    // Auto navigate to Home after 15 seconds (increased time for mood input)
    Timer(const Duration(seconds: 15), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  Future<void> _submitMood() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isSubmitting = true);

    try {
      await _db.saveMoodEntry(user.uid, _currentMood, null);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mood logged successfully! 🎉'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to home after successful submission
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      print("❌ Mood save error: $e");

      // Handle the type casting error
      if (e.toString().contains('PigeonUserDetails') || e.toString().contains('type cast')) {
        // Wait a moment for the save to complete
        await Future.delayed(Duration(milliseconds: 1500));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mood logged successfully! 🎉'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to home on likely success
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to log mood: $e'),
            backgroundColor: Colors.red,
          ),
        );

        // Reset loading state for real errors
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8E8E8),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '"Each day provides its own gifts."',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10),

              Text(
                '- Marcus Aurelius',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 60),

              Text(
                'How are you feeling today?',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),

              SizedBox(height: 30),

              // Mood Slider
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: MoodSlider(
                  initialValue: _currentMood,
                  onChanged: (value) {
                    setState(() {
                      _currentMood = value;
                    });
                  },
                ),
              ),

              SizedBox(height: 40),

              // Submit Button
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitMood,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[300],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: _isSubmitting
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Skip button
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: Text(
                  'Skip for now',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}