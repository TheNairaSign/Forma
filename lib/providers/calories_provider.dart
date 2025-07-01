import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/hive/adapter/calory_state.dart';
import 'package:workout_tracker/models/enums/workout_group.dart';
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
        weightKg: weightKg,
        durationMinutes: durationMinutes,
      ),
      timestamp: DateTime.now(),
      source: 'workout:$workoutName'
    );
  }

  void calculateCalories({
    required WorkoutGroup group,
    double? weightKg,
    int? durationSeconds,
    int? sets,
    int? reps,
    double? distance,
    String? intensity,
  }) {
    // final durationHours = (durationSeconds ?? 0) / 3600;
    final w = weightKg ?? 70;

    switch (group) {
      case WorkoutGroup.cardio:
        final met = (intensity == 'high') ? 10.0 : 7.0;
        state = CaloryState(calories: _calorieService.calculateWorkoutCalories(
          metValue: met,
          durationMinutes: (durationSeconds ?? 0) ~/ 60,
          weightKg: w,
        ),
        timestamp: DateTime.now(),
      );
      // return met * w * durationHours;
      case WorkoutGroup.time:
      case WorkoutGroup.flow:
      state = CaloryState(calories: _calorieService.calculateWorkoutCalories(
        metValue: 5.0, 
        durationMinutes: (durationSeconds ?? 0)  ~/ 60, 
        weightKg: w,
      ), 
      timestamp: DateTime.now()
      );
        // return 5.0 * w * durationHours;
      case WorkoutGroup.repetition:
      case WorkoutGroup.strength:
        final totalReps = (sets ?? 0) * (reps ?? 0);
        state = CaloryState(calories: _calorieService.calculateWorkoutCalories(
          metValue: (totalReps * 0.1), 
          durationMinutes: (durationSeconds ?? 0)  ~/ 60, 
          weightKg: (weightKg ?? 0) ,
        ), 
        timestamp: DateTime.now()
        );
        // return (totalReps * 0.1) + ((weightKg ?? 0) * 0.05);
    }
  }

  // Future<void> addNewCalories() async {

  // }

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