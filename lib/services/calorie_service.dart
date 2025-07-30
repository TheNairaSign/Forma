import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:workout_tracker/hive/adapter/calory_state.dart';
import 'package:workout_tracker/providers/box_providers.dart';

class CalorieService {
  final Box<CaloryState> _calorieBox;

  CalorieService(this._calorieBox);

  List<CaloryState> getDailyCalories(DateTime date) {
    return _calorieBox
       .values
       .where((entry) {
      final d = entry.timestamp;
      return d.year == date.year && d.month == date.month && d.day == date.day;
    }).toList();
  }

  int getDailyTotal(DateTime date) {
    final entries = getDailyCalories(date);
    return entries.fold(0, (sum, e) => sum + e.calories);
  }

  List<List<CaloryState>> getWeeklyCalories() {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    List<List<CaloryState>> weekly = [];
    for (int i = 0; i < 7; i++) {
      final day = start.add(Duration(days: i));
      final entries = getDailyCalories(day);
      weekly.add(entries);
    }
    return weekly;
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  List<int> getWeeklyTotals(int steps) {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final weekly = getWeeklyCalories();

    return List.generate(7, (i) {
      final date = start.add(Duration(days: i));
      final total = weekly[i].fold(0, (sum, e) => sum + e.calories);
      return isToday(date) ? total + calculateStepsCalories(steps) : total;
    });
  }

  void addCalories(int amount, {String? source}) {
    final entry = CaloryState(
      calories: amount,
      timestamp: DateTime.now(),
      source: source,
    );
    _calorieBox.add(entry);
  }

  CaloryState addWorkoutCalories({
    required String workoutName,
    required double metValue,
    required double durationMinutes,
    required double weightKg,
  }) {
    final cal = calculateWorkoutCalories(
      metValue: metValue,
      durationMinutes: durationMinutes,
      weightKg: weightKg,
    );
    final state = CaloryState(
      calories: cal,
      timestamp: DateTime.now(),
      source: 'workout:$workoutName',
    );
    _calorieBox.add(state);
    return state;
  }

  void resetToday() {
    final now = DateTime.now();
    final today = getDailyCalories(now);
    for (var e in today) {
      final idx = _calorieBox.values.toList().indexOf(e);
      if (idx != -1) _calorieBox.deleteAt(idx);
    }
  }

  int calculateStepsCalories(int steps, {double weightKg = 70, bool isRunning = false}) {
    return isRunning
        ? (steps * 0.75 * weightKg ~/ 1000)
        : (steps * 0.04).truncate();
  }

  int calculateWorkoutCalories({
    required double metValue,
    required double durationMinutes,
    required double weightKg,
  }) {
    return ((metValue * 3.5 * weightKg / 200) * durationMinutes).truncate();
  }

  int getDailyCaloriesFromSource(DateTime date, String source) {
    final entries = getDailyCalories(date);
    return entries
        .where((e) => e.source?.startsWith(source) ?? false)
        .fold(0, (sum, e) => sum + e.calories);
  }

  int getDailyStepsCalories(DateTime date) {
    return getDailyCaloriesFromSource(date, 'steps');
  }

  int getDailyWorkoutCalories(DateTime date) {
    return getDailyCaloriesFromSource(date, 'workout');
  }

  int getCalorieForDay(DateTime date, {required int steps}) {
    final base = getDailyTotal(date);
    final workout = getDailyWorkoutCalories(date);
    final stepCal = isToday(date) ? calculateStepsCalories(steps) : 0;
    return base + workout + stepCal;
  }

  void clearCaloriesByDay(DateTime date) {
    final entries = getDailyCalories(date);
    for (var entry in entries) {
      final idx = _calorieBox.values.toList().indexOf(entry);
      if (idx != -1) _calorieBox.deleteAt(idx);
    }
  }
}

final caloryServiceProvider = Provider<CalorieService>((ref) {
  var calorieBox = ref.watch(caloriesBoxProvider);
  if (!calorieBox.isOpen) {
    Future.delayed(Duration(seconds: 3), () async {
      calorieBox = await Hive.openBox<CaloryState>('calorieBox_');
    });
  }
  return CalorieService(calorieBox);
});