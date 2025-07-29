import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  String quote = '';
  String author = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuote();

    // Auto navigate to Home after 5 seconds
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
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
        quote = 'Could not load quote.';
        author = '';
        isLoading = false;
      });
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
              isLoading
                  ? CircularProgressIndicator()
                  : Column(
                    children: [
                      Text(
                        '"$quote"',
                        style: const TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '- $author',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

              SizedBox(height: 60),

              Text(
                'How are you feeling today?',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),

              SizedBox(height: 40),

              // Mood slider placeholder
              Container(
                width: 300,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Mood Slider (Coming Soon)',
                    style: TextStyle(color: Colors.purple[600]),
                  ),
                ),
              ),

              SizedBox(height: 40),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Mood logged!')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[300],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
