import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/providers/calories_provider.dart';
import 'package:workout_tracker/providers/last_reset_provider.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';

class DailyResetService {
  final WidgetRef ref;

  DailyResetService(this.ref);

  Future<void> resetDailyDataIfNeeded() async {
    final lastReset = ref.read(lastResetProvider);
    final now = DateTime.now();

    if (lastReset == null || now.difference(lastReset).inDays >= 1) {
      // Reset daily data
      ref.read(workoutItemProvider.notifier).clearWorkouts(null, DateTime.now(), showAlert: false);
      ref.read(stepsProvider.notifier).clearSteps();
      ref.read(caloryProvider.notifier).clearCalories();

      // Update the last reset timestamp
      ref.read(lastResetProvider.notifier).updateResetTime(now);
    }
  }
}
