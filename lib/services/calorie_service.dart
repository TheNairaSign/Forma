import 'package:hive/hive.dart';
import 'package:workout_tracker/hive/adapter/calory_state.dart';

class CalorieService {
  final String userId;

  CalorieService({required this.userId});

  // <Box<CaloryState>> get _calorieBox =>
  //   HiveBoxManager.openUserBox<CaloryState>(
  //     boxType: 'calories',
  //     userId: userId,
  //   );

  Box<CaloryState> get _calorieBox => Hive.box<CaloryState>('calorieBox_$userId');

  List<CaloryState> getDailyCalories(DateTime date) {
    final box = _calorieBox;
    return box.values.where((entry) {
      final d = entry.timestamp;
      return d.year == date.year && d.month == date.month && d.day == date.day;
    }).toList();
  }

  int getDailyTotal(DateTime date) {
    final entries = getDailyCalories(date);
    final newEntries = entries.fold(0, (sum, e) => sum + e.calories);
    return newEntries;
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
    final box = _calorieBox;
    final entry = CaloryState(
      calories: amount,
      timestamp: DateTime.now(),
      source: source,
    );
    box.add(entry);
  }

  void addStepsCalories(int steps, {double weightKg = 70, bool isRunning = false}) {
    final cal = calculateStepsCalories(steps, weightKg: weightKg, isRunning: isRunning);
    addCalories(cal, source: 'steps');
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
    final box = _calorieBox;
    box.add(state);
    return state;
  }

  void resetToday() {
    final box = _calorieBox;
    final now = DateTime.now();
    final today = getDailyCalories(now);
    for (var e in today) {
      final idx = box.values.toList().indexOf(e);
      if (idx != -1) box.deleteAt(idx);
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
    final newEntry = entries
        .where((e) => e.source?.startsWith(source) ?? false)
        .fold(0, (sum, e) => sum + e.calories);
    return newEntry;
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
    final box = _calorieBox;
    final entries = getDailyCalories(date);
    for (var entry in entries) {
      final idx = box.values.toList().indexOf(entry);
      if (idx != -1) box.deleteAt(idx);
    }
  }

  List<CaloryState> getAllEntries() {
    final box = _calorieBox;
    return box.values.toList();
  }
}
