import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'quote_screen.dart';
import 'journal_screen.dart';
import 'affirmations_screen.dart';
import 'breathing_screen.dart';

class HomeScreen extends StatelessWidget {
  // Remove const from here since we're using non-const AuthService
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Move AuthService inside build method
    final AuthService auth = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('MindMate Dashboard'),
        backgroundColor: Colors.purple[300],
        foregroundColor: Colors.white,
        actions: [
          // Profile button
          PopupMenuButton(
            icon: Icon(Icons.account_circle),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to profile
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () async {
                    Navigator.pop(context);
                    await auth.signOut();
                    // AuthWrapper will automatically handle navigation
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          _buildTile(context, 'Quote of the Day', Icons.format_quote, QuoteScreen()),
          _buildTile(context, 'Affirmations', Icons.self_improvement, const AffirmationsScreen()),
          _buildTile(context, 'Breathe', Icons.air, const BreathingScreen()),
          _buildTile(context, 'My Journal', Icons.book, JournalScreen()),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, String title, IconData icon, Widget targetScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen));
      },
      child: Card(
        elevation: 4,
        color: Colors.purple[50],
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.purple[400]),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.purple[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}