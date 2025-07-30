import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';
import 'package:workout_tracker/views/widgets/custom_progress_indicator.dart';

class ProgressContainer extends ConsumerWidget {
  const ProgressContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutAsync = ref.watch(workoutItemProvider);
    // final totalWorkouts = workouts.length;
    //
    const double workoutTarget = 10.0;
    // final double progress = workoutTarget > 0 ? (totalWorkouts / workoutTarget).clamp(0.0, 1.0) : 0.0;

    final textTheme = Theme.of(context).textTheme;
    return  workoutAsync.when(
      data: (workouts) {
        final today = DateTime.now();

        final todaysWorkouts = workouts.where((workout) =>
          workout.sessions.any((session) =>
          session.timestamp.year == today.year &&
            session.timestamp.month == today.month &&
            session.timestamp.day == today.day
          )
        ).toList();
        final totalWorkouts = todaysWorkouts.length;
        final double progress = workoutTarget > 0 ? (totalWorkouts / workoutTarget).clamp(0.0, 1.0) : 0.0;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Workout Progress', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)),
                  const SizedBox(height: 8),
                  Text('$totalWorkouts workouts done today', style: textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                ],
              ),
              CustomProgressIndicator(end: progress, textColor: Colors.white)
            ],
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, st) => Text("Error loading progress"),
    );
  }
}