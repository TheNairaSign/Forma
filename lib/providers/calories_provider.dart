import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:workout_tracker/hive/adapter/calory_state.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';

class CaloryNotifier extends StateNotifier<CaloryState> {
  final Ref ref;
  CaloryNotifier(this.ref) : super(CaloryState(calories: 0, timestamp: DateTime.now()));

  late final Box<CaloryState> _calorieBox = Hive.box<CaloryState>('calories');

  List<CaloryState> get allEntries => _calorieBox.values.toList();

  double _overallCalories = 0;

  void init(Ref ref) {
  }

  double get todayTotal {
    final stepsCalory = ref.watch(stepsProvider.notifier).getStepsCalory();

    final now = DateTime.now();
    final today = _calorieBox.values.where((entry) =>
        entry.timestamp.year == now.year &&
        entry.timestamp.month == now.month &&
        entry.timestamp.day == now.day);
    final total = today.fold<double>(0, (sum, entry) => sum + entry.calories) + stepsCalory;
    debugPrint('Today total calories: $total');
    return total;
  }

  List<CaloryState> getDailyCalories(DateTime date) {
    final dailyCalories = _calorieBox.values.where((entry) {
      final entryDate = entry.timestamp;
      return entryDate.year == date.year && 
             entryDate.month == date.month && 
             entryDate.day == date.day;
    }).toList();

    // Add steps calories if getting today's calories
    final now = DateTime.now();
    if (date.year == now.year && 
        date.month == now.month && 
        date.day == now.day) {
      final stepsCalory = ref.read(stepsProvider.notifier).getStepsCalory();
      dailyCalories.add(CaloryState(
        calories: stepsCalory.toDouble(),
        timestamp: now
      ));
    }

    return dailyCalories;
  }

  List<CaloryState> getWeeklyCalories() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final weeklyCalories = <CaloryState>[];

    // Create a list of CaloryState objects for each day of the week
    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      
      // Get all entries for this specific day
      final dayEntries = _calorieBox.values.where((entry) {
        final entryDate = entry.timestamp;
        return entryDate.year == date.year && 
               entryDate.month == date.month && 
               entryDate.day == date.day;
      }).toList();
      
      // Calculate total calories for this day
      double dayTotal = dayEntries.fold(0.0, (sum, entry) => sum + entry.calories);
      
      // Add steps calories for today only
      if (date.year == now.year && date.month == now.month && date.day == now.day) {
        dayTotal += ref.read(stepsProvider.notifier).getStepsCalory();
      }
      
      // Create a CaloryState for this day with the total calories
      weeklyCalories.add(CaloryState(
        calories: dayTotal.toDouble(), 
        timestamp: date
      ));
    }
    
    // Calculate overall weekly total
    _overallCalories = weeklyCalories.fold(0.0, (sum, day) => sum + day.calories);
    
    debugPrint('Weekly total calories: $_overallCalories');
    return weeklyCalories;
  }

  Future<void> addCalories(double amount) async {
    final newState = CaloryState(
      calories: amount,
      timestamp: DateTime.now(),
    );
    state = newState;
    await _calorieBox.add(newState);
  }

  Future<void> resetToday() async {
    try {
      final now = DateTime.now();
      final todayKeys = _calorieBox.keys.where((key) {
        final entry = _calorieBox.get(key);
        if (entry == null) return false;
        return entry.timestamp.year == now.year &&
            entry.timestamp.month == now.month &&
            entry.timestamp.day == now.day;
      }).toList();

      for (final key in todayKeys) {
        await _calorieBox.delete(key);
      }
      state = state.copyWith(calories: 0, timestamp: DateTime.now());
    } catch (e) {
      debugPrint('Error resetting today\'s calories: $e');
    }
  }

  List<double> weeklyCaloryChartData() => getWeeklyCalories().map((entry) => entry.calories.toDouble()).toList();

  /// If you want to estimate calories from steps
  /// 
  /// If user does not provide their weight, you can use the following formula:
  double estimateCaloriesFromSteps(int steps, {double weightKg = 70}) {
  // Simple average formula
  return steps * 0.04;
  }

  /// More accurate formula
  /// 
  /// If user provides their weight and whether they are running or walking, you can use the following formula:
  // TODO: Prompt use for weight and isRunning
  // TODO: Add isRunning parameter
  double estimateCaloriesFromStepsAccurate(int steps, double weightKg, {bool isRunning = false}) {
    double multiplier = isRunning ? 0.75 : 0.57;
    return (steps * multiplier * weightKg) / 1000;
  }

  double estimateCaloriesFromWorkout({
    required double metValue,
    required double durationMinutes,
    required double weightKg,
  }) {
    double durationHours = durationMinutes / 60;
    return metValue * weightKg * durationHours;
  }

}

final caloryProvider = StateNotifierProvider<CaloryNotifier, CaloryState>((ref) => CaloryNotifier(ref));