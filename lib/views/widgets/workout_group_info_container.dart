import 'package:flutter/material.dart';

class WorkoutGroupInfoContainer extends StatefulWidget {
  const WorkoutGroupInfoContainer({super.key});

  @override
  State<WorkoutGroupInfoContainer> createState() => _WorkoutGroupInfoContainerState();
}

class _WorkoutGroupInfoContainerState extends State<WorkoutGroupInfoContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Workout Group',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Workout Type',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          
        ],
      ),
    );
  }
}