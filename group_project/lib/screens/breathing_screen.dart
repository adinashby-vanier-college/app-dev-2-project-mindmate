import 'dart:async';
import 'package:flutter/material.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
  String _phase = "Tap Start to begin";
  bool _isBreathing = false;
  Timer? _timer;
  int _timeLeft = 0;

  void _startBreathing() {
    setState(() {
      _isBreathing = true;
      _startPhase("Inhale", 4);
    });
  }

  void _startPhase(String phase, int duration) {
    setState(() {
      _phase = phase;
      _timeLeft = duration;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 1) {
        setState(() {
          _timeLeft--;
        });
      } else {
        timer.cancel();
        if (phase == "Inhale") {
          _startPhase("Hold", 4);
        } else if (phase == "Hold") {
          _startPhase("Exhale", 6);
        } else if (phase == "Exhale") {
          _startPhase("Inhale", 4); // loop again
        }
      }
    });
  }

  void _stopBreathing() {
    _timer?.cancel();
    setState(() {
      _isBreathing = false;
      _phase = "Tap Start to begin";
      _timeLeft = 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Breathing Exercise")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _phase,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              if (_isBreathing && _timeLeft > 0)
                Text(
                  "$_timeLeft s",
                  style: const TextStyle(fontSize: 24, color: Colors.black54),
                ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_isBreathing) {
                    _stopBreathing();
                  } else {
                    _startBreathing();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[300],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  _isBreathing ? "Stop" : "Start",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
