import 'package:flutter/material.dart';
import 'quote_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MindMate Dashboard'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          _buildTile(context, 'Quote of the Day', Icons.format_quote, QuoteScreen()),
          _buildTile(context, 'Affirmations', Icons.self_improvement, Placeholder()),
          _buildTile(context, 'Breathe', Icons.air, Placeholder()),
          _buildTile(context, 'My Journal', Icons.book, Placeholder()),
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
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40),
              const SizedBox(height: 10),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
