import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';

class ProgressNotifier extends StateNotifier<int> {
  final Ref ref;
  ProgressNotifier(this.ref) : super(0);

  int calculateProgress(int current, int total) {
    if (total <= 0) {
      state = 0;
      return 0;
    }
    
    double percentage = (current / total) * 100;
    // Ensure the percentage is between 0 and 100
    percentage = percentage.clamp(0.0, 100.0);
    // Round to nearest integer
    state = percentage.round();
    return state;
  }

  int stepsProgress() {
    final steps = ref.watch(stepsProvider);
    return calculateProgress(steps.steps, ref.watch(stepsProvider.notifier).dailyTargetSteps);
  }

  void resetProgress() => state = 0;

  int get progressPercentage => state;
}

final progressProvider = StateNotifierProvider<ProgressNotifier, int>((ref) => ProgressNotifier(ref));