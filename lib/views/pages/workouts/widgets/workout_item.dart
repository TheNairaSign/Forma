import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/models/enums/workout_group.dart';
import 'package:workout_tracker/models/enums/workout_type.dart';
import 'package:workout_tracker/models/workout/workout.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';
import 'package:workout_tracker/views/pages/workouts/widgets/dismiss_item.dart';

class WorkoutItem extends ConsumerWidget {
  const WorkoutItem({super.key, required this.workout, required this.type});
  final Workout workout;
  final WorkoutType type;

  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }

  String subtitle() {
    final sets = workout.sets ?? '--';
    final reps = workout.reps ?? '--';
    final duration = _formatTime(workout.durationInSeconds);
    final distance = workout.distance?.toStringAsFixed(2) ?? '--';

    switch (workout.workoutGroup) {
      case WorkoutGroup.repetition:
        return '$sets sets • $reps reps • $duration total';

      case WorkoutGroup.time:
        return 'Duration: $duration';

      case WorkoutGroup.flow:
        return 'Flow • Duration: $duration';

      case WorkoutGroup.strength:
        return '$sets sets • $reps reps • Strength training';

      case WorkoutGroup.cardio:
        return 'Cardio • $distance km • $duration';

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
      subtitle: subtitle(),
      onDismissed: (direction) => ref.watch(workoutItemProvider.notifier).deleteWorkout(workout),
    );
  }
}
