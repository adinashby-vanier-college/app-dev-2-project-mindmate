import 'package:flutter/material.dart';

class MoodSlider extends StatefulWidget {
  final double initialValue;
  final Function(double) onChanged;
  final bool showLabel;

  const MoodSlider({
    Key? key,
    this.initialValue = 5.0,
    required this.onChanged,
    this.showLabel = true,
  }) : super(key: key);

  @override
  State<MoodSlider> createState() => _MoodSliderState();
}

class _MoodSliderState extends State<MoodSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  String _getMoodLabel(double value) {
    if (value <= 2) return 'Very Sad 😢';
    if (value <= 4) return 'Sad 😕';
    if (value <= 6) return 'Neutral 😐';
    if (value <= 8) return 'Happy 😊';
    return 'Very Happy 😄';
  }

  Color _getMoodColor(double value) {
    if (value <= 2) return Colors.red;
    if (value <= 4) return Colors.orange;
    if (value <= 6) return Colors.yellow;
    if (value <= 8) return Colors.lightGreen;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showLabel) ...[
          Text(
            _getMoodLabel(_currentValue),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: _getMoodColor(_currentValue),
            ),
          ),
          SizedBox(height: 10),
        ],

        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _getMoodColor(_currentValue),
              inactiveTrackColor: Colors.grey[300],
              thumbColor: _getMoodColor(_currentValue),
              overlayColor: _getMoodColor(_currentValue).withOpacity(0.2),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 25),
            ),
            child: Slider(
              value: _currentValue,
              min: 1.0,
              max: 10.0,
              divisions: 9,
              label: _currentValue.round().toString(),
              onChanged: (value) {
                setState(() {
                  _currentValue = value;
                });
                widget.onChanged(value);
              },
            ),
          ),
        ),

        if (widget.showLabel) ...[
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1', style: TextStyle(color: Colors.grey[600])),
              Text('10', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ],
      ],
    );
  }
}