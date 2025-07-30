// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/hive/adapter/calory_state.dart';
import 'package:workout_tracker/models/enums/workout_group.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';
import 'package:workout_tracker/services/calorie_service.dart';
import 'package:workout_tracker/utils/flush/flushbar_service.dart';

class CaloryNotifier extends AsyncNotifier<CaloryState> {
  CalorieService get _calorieService => ref.watch(caloryServiceProvider);


  @override
  Future<CaloryState> build() async {
    final calories = _calorieService.getCalorieForDay(DateTime.now(), steps: ref.read(stepsProvider).steps);
    print('CaloryNotifier initialized with calories: $calories');
    final initialState = CaloryState(calories: calories, timestamp: DateTime.now(), source: 'initial');
    state = AsyncValue.data(initialState);
    return initialState;
  }

  int _targetCalories = 2000; // Default target calories
  int get targetCalories => _targetCalories;

  final _targetCalorieController = TextEditingController(text: '2000');
  TextEditingController get targetCaloriesController => _targetCalorieController;

  void updateTargetCalories(BuildContext context) {
    if (_targetCalorieController.text.isEmpty) {
      print('Target calorie input is empty, using default value: $_targetCalories');
      return; // No update if input is empty
    }
    final newTarget = int.tryParse(_targetCalorieController.text) ?? 2000;
    _targetCalories = newTarget;
    print('Updated target calories: $_targetCalories');
    FlushbarService.show(context, message: 'Updated target calories to $_targetCalories');
    AsyncValue.data(state);
  }

  int get todayTotal {
    final steps = ref.watch(stepsProvider).steps;
    final total = _calorieService.getCalorieForDay(DateTime.now(), steps: steps);
    print('todayTotal: steps: $steps, total: $total');
    return total;
  }

  List<CaloryState> getDailyCalories(DateTime date) {
    return _calorieService.getDailyCalories(date);
  }

  void addCalories(int amount) {
    final newCalorie = CaloryState(calories: amount, timestamp: DateTime.now(), source: 'manual');
    state = AsyncValue.data(newCalorie);
    _caloriesAdded = amount;
    _calorieService.addCalories(amount);
    print('Added calories: $amount, new state: ${state.value}');
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

  int? _caloriesAdded;
  int? get caloriesAdded => _caloriesAdded;

  int? _caloriesToday;
  int? get caloriesToday => _caloriesToday;

  void calculateCalories({
    required WorkoutGroup group,
    required String name,
    double? weightKg,
    int? durationSeconds,
    int? sets,
    int? reps,
  }) {
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

    final newState = _calorieService.addWorkoutCalories(
      workoutName: name,
      metValue: metValue,
      durationMinutes: durationMinutes,
      weightKg: w,
    );
    state = AsyncValue.data(newState);
    _caloriesAdded = newState.calories;
    print('Calculated calorie from state: ${newState.source}: ${newState.calories}');
  }

  void clearCalories() {
    _calorieService.clearCaloriesByDay(DateTime.now());
  }

  void resetToday() {
    _calorieService.resetToday();
  }

  int getCalorieForDay(DateTime date) {
    final steps = ref.read(stepsProvider).steps;
    final total = _calorieService.getCalorieForDay(date, steps: steps);
    _caloriesToday = total;
    // state = state.copyWith(calories: total, timestamp: DateTime.now());
    return total;
  }

  List<int> getWeeklyTotals() {
    return _calorieService.getWeeklyTotals(ref.read(stepsProvider).steps);
  }

  List<int> getWeeklyCalories() {
    final now = DateTime.now();
    final List<int> weeklyCalories = [];
    final steps = ref.read(stepsProvider).steps;

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dailySteps = _calorieService.isToday(date) ? steps : 0;
      weeklyCalories.add(_calorieService.getCalorieForDay(date, steps: dailySteps));
    }

    return weeklyCalories;
  }
}

final caloriesProvider = AsyncNotifierProvider<CaloryNotifier, CaloryState>(() {
  return CaloryNotifier();
});