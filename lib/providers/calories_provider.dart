import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/hive/adapter/calory_state.dart';
import 'package:workout_tracker/models/enums/workout_group.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';
import 'package:workout_tracker/services/calorie_service.dart';

class CaloryNotifier extends StateNotifier<CaloryState?> {
  final Ref ref;
  final CalorieService _calorieService = CalorieService();

  CaloryNotifier(this.ref) : super(null);

  List<CaloryState> get allEntries => _calorieService.getAllEntries();

  int get todayTotal {
    final steps = ref.watch(stepsProvider).steps;
    final total = _calorieService.getCalorieForDay(DateTime.now(), steps: steps);
    print('todayTotal: steps: $steps, total: $total');
    return total;
  }

  List<CaloryState> getDailyCalories(DateTime date) {
    return _calorieService.getDailyCalories(date);
  }

  Future<void> addCalories(int amount) async {
    await _calorieService.addCalories(amount);
    // Optionally, update state if needed, though the main total is what matters.
    state = CaloryState(calories: amount, timestamp: DateTime.now(), source: 'manual');
  }

  int estimateDurationSeconds({
    required int sets,
    required int reps,
    int repTime = 4,           // seconds per rep
    int restTime = 60,         // rest between sets
  }) {
    final exerciseTime = sets * reps * repTime;
    final totalRest = (sets - 1) * restTime;
    return exerciseTime + totalRest;
  }


  Future<void> calculateCalories({
    required WorkoutGroup group,
    required String name,
    double? weightKg,
    int? durationSeconds,
    int? sets,
    int? reps,
  }) async {
    final w = weightKg ?? 70.0; // Default weight if not provided
    final estimate = estimateDurationSeconds(sets: sets ?? 1, reps: reps ?? 1);
    print('Estimated Duration: $estimate');
    final durationMinutes = (durationSeconds == 0 ? estimate : durationSeconds)! / 60.0;
    print('Duration in minutes: $durationMinutes');
    double metValue;

    switch (group) {
      case WorkoutGroup.cardio:
        metValue = 7.0;
        break;
      case WorkoutGroup.time:
      case WorkoutGroup.flow:
        metValue = 4.0;
        break;
      case WorkoutGroup.repetition:
      case WorkoutGroup.strength:
        metValue = 5.0;
        break;
    }

    final newState = await _calorieService.addWorkoutCalories(
      workoutName: name,
      metValue: metValue,
      durationMinutes: durationMinutes,
      weightKg: w,
    );
    state = newState;
    print('Calculated calorie from state: ${newState.source}: ${newState.calories}');
  }

  Future<void> clearCalories() async {
    await _calorieService.clearCaloriesByDay(DateTime.now());
    state = null;
  }

  Future<void> resetToday() async {
    await _calorieService.resetToday();
    state = null;
  }

  int getCalorieForDay(DateTime date) {
    final steps = ref.read(stepsProvider).steps;
    return _calorieService.getCalorieForDay(date, steps: steps);
  }

  List<int> getWeeklyCalories() {
    final now = DateTime.now();
    final List<int> weeklyCalories = [];
    final steps = ref.read(stepsProvider).steps;

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      // For past days, steps are not counted, so we pass 0.
      final dailySteps = _calorieService.isToday(date) ? steps : 0;
      weeklyCalories.add(_calorieService.getCalorieForDay(date, steps: dailySteps));
    }

    return weeklyCalories;
  }
}

final caloryProvider = StateNotifierProvider<CaloryNotifier, CaloryState?>((ref) => CaloryNotifier(ref));