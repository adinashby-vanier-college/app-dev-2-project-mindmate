import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AffirmationsScreen extends StatefulWidget {
  const AffirmationsScreen({super.key});

  @override
  State<AffirmationsScreen> createState() => _AffirmationsScreenState();
}

class _AffirmationsScreenState extends State<AffirmationsScreen> {
  String affirmation = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAffirmation();
  }

  Future<void> fetchAffirmation() async {
    try {
      final response =
      await http.get(Uri.parse('https://www.affirmations.dev/'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          affirmation = data['affirmation'];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        affirmation = 'Could not load affirmation.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Affirmation")),
      backgroundColor: const Color(0xFFE8E8E8),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            '"$affirmation"',
            style: const TextStyle(
              fontSize: 22,
              fontStyle: FontStyle.italic,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchAffirmation,
        backgroundColor: Colors.purple[300],
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
