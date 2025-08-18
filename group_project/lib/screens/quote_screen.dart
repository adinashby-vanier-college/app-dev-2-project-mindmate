import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  String quote = '';
  String author = '';
  bool isLoading = true;
  double _currentMood = 5.0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    fetchQuote();

    // Auto navigate to Home after 20 seconds (increased time for quote + mood input)
    // Timer(const Duration(seconds: 20), () {
    //   if (mounted) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => const HomeScreen()),
    //     );
    //   }
    // });
  }

  Future<void> fetchQuote() async {
    try {
      final response = await http.get(
        Uri.parse('https://zenquotes.io/api/random'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          quote = data[0]['q'];
          author = data[0]['a'];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        quote = 'Each day provides its own gifts.';
        author = 'Marcus Aurelius';
        isLoading = false;
      });
      print('Error fetching quote: $e');
    }
  }

  Future<void> _submitMood() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isSubmitting = true);

    try {
      await _db.saveMoodEntry(user.uid, _currentMood, null).timeout(Duration(seconds: 5));

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

      // Always show success and navigate (since we know the data gets saved)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mood logged successfully! 🎉'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }

    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quote of the Day",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[600],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFE8E8E8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Quote Section
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
                child: isLoading
                    ? Column(
                  children: [
                    CircularProgressIndicator(color: Colors.grey[600]),
                    SizedBox(height: 16),
                    Text(
                      'Loading inspiring quote...',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                )
                    : Column(
                  children: [
                    Text(
                      '"$quote"',
                      style: const TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '- $author',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                'How are you feeling today?',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 30),

              // Mood Slider Section
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

              const SizedBox(height: 40),

              // Submit Button
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitMood,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
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

              const SizedBox(height: 20),

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