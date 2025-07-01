import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/providers/progress_provider.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';
import 'package:workout_tracker/views/widgets/custom_progress_indicator.dart';

class ProgressContainer extends ConsumerStatefulWidget {
  const ProgressContainer({super.key});

  @override
  ConsumerState<ProgressContainer> createState() => _ProgressContainerState();
}

class _ProgressContainerState extends ConsumerState<ProgressContainer> {
  
  @override
  Widget build(BuildContext context) {
    final workouts = ref.watch(workoutItemProvider);
    final progress = ref.watch(progressProvider).toDouble();
    final totalWorkouts = workouts.length;
    // final completedWorkouts = workouts.where((workout) => workout.isCompleted).length;
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
              Text('$totalWorkouts workouts done today', style: textTheme.bodyMedium?.copyWith(color: Colors.grey)),
            ],
          ),
          CustomProgressIndicator(end: progress, textColor: Colors.white)
        ],
      ),
    );
  }
}