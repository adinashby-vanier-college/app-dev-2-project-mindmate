import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8E8E8),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // MindMate Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.purple[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.psychology_outlined,
                  size: 60,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 30),

              Text(
                'MindMate',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[300],
                  letterSpacing: 1.2,
                ),
              ),

              SizedBox(height: 120),

              // Log In Button
              Container(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.login, size: 20),
                      SizedBox(width: 8),
                      Text('Log In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Register Button
              Container(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[300],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add, size: 20),
                      SizedBox(width: 8),
                      Text('Register', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Temporary message
              Text(
                'Basic login only - Google coming soon',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}