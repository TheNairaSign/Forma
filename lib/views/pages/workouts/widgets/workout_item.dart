import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/models/workout/workout.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';
import 'package:workout_tracker/services/workout_service.dart';
import 'package:workout_tracker/views/pages/workouts/widgets/dismiss_item.dart';

class WorkoutItem extends ConsumerWidget {
  WorkoutItem({super.key, required this.workout});
  final Workout workout;

  final _workoutService = WorkoutService();

  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DismissibleItem(
      id: workout.id,
      title: workout.name,
      subtitle: '${workout.sets} sets, ${workout.reps} reps, Total: ${_formatTime(workout.durationInSeconds)}',
      onDismissed: (direction) async {
        await _workoutService.deleteWorkout(workout.id).then((_) {
          ref.read(workoutItemProvider.notifier).getWorkouts();
        });
      },
    );
  }
}
