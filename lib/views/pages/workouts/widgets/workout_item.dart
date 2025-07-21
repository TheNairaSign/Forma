import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/models/enums/workout_group.dart';
import 'package:workout_tracker/models/enums/workout_type.dart';
import 'package:workout_tracker/models/workout/workout.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';
import 'package:workout_tracker/services/workout_service.dart';
import 'package:workout_tracker/views/pages/workouts/widgets/dismiss_item.dart';

class WorkoutItem extends ConsumerWidget {
  WorkoutItem({super.key, required this.workout, required this.type});
  final Workout workout;
  final WorkoutType type;

  final _workoutService = WorkoutService();

  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }

  String subtitle(Workout workout) {
  switch (workout.workoutGroup) {
    case WorkoutGroup.repetition:
      return '${workout.sets} sets • ${workout.reps} reps • ${_formatTime(workout.durationInSeconds)} total';

    case WorkoutGroup.time:
      return 'Duration: ${_formatTime(workout.durationInSeconds)}';

    case WorkoutGroup.flow:
      return 'Flow • Duration: ${_formatTime(workout.durationInSeconds)}';

    case WorkoutGroup.strength:
      return '${workout.sets} sets • ${workout.reps} reps • Strength training';

    case WorkoutGroup.cardio:
      final distance = workout.distance?.toStringAsFixed(2) ?? '--';
      return 'Cardio • $distance km • ${_formatTime(workout.durationInSeconds)}';

    default:
      return 'Workout Summary';
  }
}


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DismissibleItem(
      workout: workout,
      id: workout.id,
      title: workout.name,
      subtitle: '${workout.sets} sets, ${workout.reps} reps, Duration: ${_formatTime(workout.durationInSeconds)}',
      onDismissed: (direction) async {
        await _workoutService.deleteWorkout(workout.id).then((_) {
          ref.watch(workoutItemProvider.notifier).getWorkouts();
        });
      },
    );
  }
}
