import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:workout_tracker/hive/adapter/calory_state.dart';

class CalorieService {
  static final CalorieService _instance = CalorieService._internal();
  factory CalorieService() => _instance;
  CalorieService._internal();

  final Box<CaloryState> _calorieBox = Hive.box<CaloryState>('calorieBox');

  /// Get all calorie entries for a specific day
  List<CaloryState> getDailyCalories(DateTime date) {
    return _calorieBox.values.where((entry) {
      final entryDate = entry.timestamp;
      return entryDate.year == date.year && 
             entryDate.month == date.month && 
             entryDate.day == date.day;
    }).toList();
  } 

  /// Get total calories for a specific day
  int getDailyTotal(DateTime date) {
    final entries = getDailyCalories(date);
    for (var entry in entries) {
      print('Calory Entry Data: ${entry.source}, ${entry.calories}, ${entry.timestamp}');
    }
    final todayTotal = entries.fold(0, (sum, entry) {
      debugPrint('Sum: $sum + Entry: ${entry.calories}');
      return sum + entry.calories;
    });
    print('Today total: $todayTotal');
    return todayTotal;
  }

  /// Get all calorie entries for the current week
  List<List<CaloryState>> getWeeklyCalories() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final weeklyCalories = <List<CaloryState>>[];

    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      weeklyCalories.add(getDailyCalories(date));
    }

    return weeklyCalories;
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  /// Get weekly calories as a list of daily totals
  List<int> getWeeklyTotals(int steps) {
    final weeklyCalories = getWeeklyCalories();
    final now = DateTime.now();
    
    return List.generate(7, (index) {
      final date = now.subtract(Duration(days: now.weekday - 1)).add(Duration(days: index));
      final dailyTotal = weeklyCalories[index].fold(0, (sum, entry) => sum + entry.calories);
      
      // Add steps calories only for today
      if (isToday(date)) {
        return (dailyTotal + calculateStepsCalories(steps));
      }
      return dailyTotal;
    });
  }

  /// Add a new calorie entry
  Future<void> addCalories(int amount) async {
    final newState = CaloryState(
      calories: amount,
      timestamp: DateTime.now(),
    );
    await _calorieBox.add(newState);
  }

  /// Reset all calorie entries for today
  Future<void> resetToday() async {
    try {
      final now = DateTime.now();
      final todayEntries = getDailyCalories(now);
      
      for (final entry in todayEntries) {
        final key = _calorieBox.values.toList().indexOf(entry);
        if (key != -1) {
          await _calorieBox.deleteAt(key);
        }
      }
    } catch (e) {
      debugPrint('Error resetting today\'s calories: $e');
    }
  }

  /// Get all calorie entries
  List<CaloryState> getAllEntries() {
    return _calorieBox.values.toList();
  }

  /// Calculate calories from steps
  int calculateStepsCalories(int steps, {double weightKg = 70, bool isRunning = false}) {
    if (isRunning) {
      return (steps * 0.75 * weightKg) ~/ 1000;
    }
    return (steps * 0.04).truncate(); // Simple calculation for walking
  }

  /// Calculate calories from workout
  int calculateWorkoutCalories({
    required double metValue,
    required double durationMinutes,
    required double weightKg,
  }) {
    print('Met: $metValue \n Duration: $durationMinutes \n Weight: $weightKg');
    // if (durationMinutes <= 0 || weightKg <= 0) {
    //   print('Duration in minutes || weight <= 0');
    //   return 0;
    // }
    // Formula: (MET * 3.5 * weight in kg) / 200 = Cals/min
    // Total Calories = Cals/min * duration in minutes
    final double calories = (metValue * 3.5 * weightKg / 200) * durationMinutes;
    print('Calory: $calories');
    return calories.truncate();
  }

  /// Add calories from steps
  Future<void> addStepsCalories(int steps, {double weightKg = 70, bool isRunning = false}) async {
    final calories = calculateStepsCalories(steps, weightKg: weightKg, isRunning: isRunning);
    await addCalories(calories);
  }

  /// Add calories from workout
  Future<CaloryState> addWorkoutCalories({
    required String workoutName,
    required double metValue,
    required double durationMinutes,
    required double weightKg,
  }) async {
    final calories = calculateWorkoutCalories(
      metValue: metValue,
      durationMinutes: durationMinutes,
      weightKg: weightKg,
    );
    
    final newState = CaloryState(
      calories: calories,
      timestamp: DateTime.now(),
      source: 'workout:$workoutName',
    );
    await _calorieBox.add(newState);
    print('The new state: ${newState.source}');
    return newState;
  }

  /// Get calories from specific source for a day
  int getDailyCaloriesFromSource(DateTime date, String source) {
    final entries = getDailyCalories(date).where((entry) => entry.source?.startsWith(source) ?? false);
    return entries.fold(0, (sum, entry) => sum + entry.calories);
  }

  /// Get steps calories for a day
  int getDailyStepsCalories(DateTime date) {
    return getDailyCaloriesFromSource(date, 'steps');
  }

  /// Get workout calories for a day
  int getDailyWorkoutCalories(DateTime date) {
    return getDailyCaloriesFromSource(date, 'workout');
  }

  /// Get total calories for a specific day including all sources
  int getCalorieForDay(DateTime date, {required int steps}) {
    // Get base calories from all entries
    final baseCalories = getDailyTotal(date);
    
    // Get workout calories
    final workoutCalories = getDailyWorkoutCalories(date);
    int stepsCalories = 0;
    if (isToday(date)) {
      stepsCalories = calculateStepsCalories(steps);
    }

    final combined = baseCalories + workoutCalories + stepsCalories;
    debugPrint('Base: $baseCalories, Workout: $workoutCalories, Steps: $stepsCalories, Combined: $combined');
    
    return combined.truncate();
  }

  /// Clear all calorie entries from the box
  Future<void> clearCalories() async {
    try {
      await _calorieBox.clear();
    } catch (e) {
      debugPrint('Error clearing calories: $e');
    }
  }
}