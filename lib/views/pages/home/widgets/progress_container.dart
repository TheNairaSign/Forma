import 'package:flutter/material.dart';
import 'package:workout_tracker/views/widgets/custom_progress_indicator.dart';

class ProgressContainer extends StatefulWidget {
  const ProgressContainer({super.key});

  @override
  State<ProgressContainer> createState() => _ProgressContainerState();
}

class _ProgressContainerState extends State<ProgressContainer> {
  
  @override
  Widget build(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Workout Progress',style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)),
              const SizedBox(height: 8),
              Text('12 Exercises left', style: textTheme.bodyMedium?.copyWith(color: Colors.grey)),
            ],
          ),
          CustomProgressIndicator(end: 0.65, textColor: Colors.white)
        ],
      ),
    );
  }
}