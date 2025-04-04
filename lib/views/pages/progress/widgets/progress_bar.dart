import 'package:flutter/material.dart';
import 'package:workout_tracker/models/progress_data.dart';

class ProgressBar extends StatefulWidget {
  const ProgressBar({super.key, required this.index});
  final int index;

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
  final progressData = ProgressData.progressDataList[widget.index];
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: 100 * progressData.height,
          decoration: BoxDecoration(
            color: ProgressData.isHighlighted(progressData.dayOfThWeek) ? Colors.green : Colors.grey.shade800, 
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20),),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          progressData.dayOfThWeek,
          style: TextStyle(
            color:  ProgressData.isHighlighted(progressData.dayOfThWeek) ? Colors.green : Colors.grey.shade400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}