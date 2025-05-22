import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/hive/adapter/calory_state.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';
import 'package:workout_tracker/services/calorie_service.dart';

class CaloryNotifier extends StateNotifier<CaloryState> {
  final Ref ref;
  final CalorieService _calorieService = CalorieService();

  CaloryNotifier(this.ref) : super(CaloryState(calories: 0, timestamp: DateTime.now()));

  List<CaloryState> get allEntries => _calorieService.getAllEntries();

  int get todayTotal {
    final now = DateTime.now();
    final stepsCalory = ref.watch(stepsProvider.notifier).getStepsCalory();
    final total = _calorieService.getDailyTotal(now) + stepsCalory;
    print('TodayTotal: $total');
    return total;
  }

  List<CaloryState> getDailyCalories(DateTime date) {
    final dailyCalories = _calorieService.getDailyCalories(date);
    
    // Add steps calories if getting today's calories
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      final stepsCalory = ref.read(stepsProvider.notifier).getStepsCalory();
      dailyCalories.add(CaloryState(
        calories: stepsCalory,
        timestamp: now,
        source: 'steps'
      ));
    }
    return dailyCalories;
  }

  Future<void> addCalories(int amount) async {
    await _calorieService.addCalories(amount);
    state = CaloryState(calories: amount, timestamp: DateTime.now());
  }

  Future<void> addWorkoutCalories({
    required String workoutName,
    required double metValue,
    required int durationMinutes,
    double weightKg = 70,
  }) async {
    print('Adding workout calories with values: $workoutName, $metValue, $durationMinutes, $weightKg');
    await _calorieService.addWorkoutCalories(
      workoutName: workoutName,
      metValue: metValue,
      durationMinutes: durationMinutes,
      weightKg: weightKg,
    );
    state = CaloryState(
      calories: _calorieService.calculateWorkoutCalories(
        metValue: metValue,
        durationMinutes: durationMinutes,
        weightKg: weightKg,
      ),
      timestamp: DateTime.now(),
      source: 'workout:$workoutName'
    );
  }

  Future<void> addStepsCalories(int steps, {double weightKg = 70, bool isRunning = false}) async {
    await _calorieService.addStepsCalories(steps, weightKg: weightKg, isRunning: isRunning);
    state = CaloryState(
      calories: _calorieService.calculateStepsCalories(steps, weightKg: weightKg, isRunning: isRunning),
      timestamp: DateTime.now(),
      source: 'steps'
    );
  }

  Future<void> resetToday() async {
    await _calorieService.resetToday();
    state = CaloryState(calories: 0, timestamp: DateTime.now());
  }

  int getCalorieForDay(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return todayTotal;
    }
    final steps = ref.read(stepsProvider).steps;
    return _calorieService.getCalorieForDay(date, steps: steps);
  }

  List<int> getWeeklyCalories() {
    final now = DateTime.now();
    final List<int> weeklyCalories = [];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      weeklyCalories.add(getCalorieForDay(date));
    }

    return weeklyCalories;
  }
}

final caloryProvider = StateNotifierProvider<CaloryNotifier, CaloryState>((ref) => CaloryNotifier(ref));