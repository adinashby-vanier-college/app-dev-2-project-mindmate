import 'package:flutter/material.dart';

class QuoteScreen extends StatelessWidget {
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
                '"Quote Of The Day!"',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 60),

              Text(
                'How are you feeling today?',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mood logged!')),
                  );
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