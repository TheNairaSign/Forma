import 'package:hive/hive.dart';
import 'package:workout_tracker/hive/adapter/calory_state.dart';
import 'package:workout_tracker/services/hive_service.dart';

class CalorieService {
  final String? userId;

  CalorieService({required this.userId});

  // <Box<CaloryState>> get _calorieBox =>
  //   HiveBoxManager.openUserBox<CaloryState>(
  //     boxType: 'calories',
  //     userId: userId,
  //   );

  Future<Box<CaloryState>> get _calorieBox async {
    final boxName = 'calorieBox_$userId';
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<CaloryState>(boxName);
    }
    return await Hive.openBox<CaloryState>(boxName);
  }

  Future<void> openBoxes() async {
    if (userId == null || userId!.isEmpty) return;
    await HiveService.openUserBoxes(userId!);
  }

  Future<List<CaloryState>> getDailyCalories(DateTime date) async {
    final box = await _calorieBox;
    return box
       .values
       .where((entry) {
      final d = entry.timestamp;
      return d.year == date.year && d.month == date.month && d.day == date.day;
    }).toList();
  }

  Future<int> getDailyTotal(DateTime date) async {
    final entries = await getDailyCalories(date);
    final newEntries = entries.fold(0, (sum, e) => sum + e.calories);
    return newEntries;
  }

  Future<List<List<CaloryState>>> getWeeklyCalories() async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    List<List<CaloryState>> weekly = [];
    for (int i = 0; i < 7; i++) {
      final day = start.add(Duration(days: i));
      final entries = await getDailyCalories(day);
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

  Future<List<int>> getWeeklyTotals(int steps) async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final weekly = await getWeeklyCalories();

    return List.generate(7, (i) {
      final date = start.add(Duration(days: i));
      final total = weekly[i].fold(0, (sum, e) => sum + e.calories);
      return isToday(date) ? total + calculateStepsCalories(steps) : total;
    });
  }

  Future<void> addCalories(int amount, {String? source}) async {
    final entry = CaloryState(
      calories: amount,
      timestamp: DateTime.now(),
      source: source,
    );
    final box = await _calorieBox;
    await box.add(entry);
  }

  Future<CaloryState> addWorkoutCalories({
    required String workoutName,
    required double metValue,
    required double durationMinutes,
    required double weightKg,
  }) async {
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
    final box = await _calorieBox;
    await box.add(state);
    return state;
  }

  Future<void> resetToday() async {
    final box = await _calorieBox;
    final now = DateTime.now();
    final today = await getDailyCalories(now);
    for (var e in today) {
      final idx = box.values.toList().indexOf(e);
      if (idx != -1) await box.deleteAt(idx);
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

  Future<int> getDailyCaloriesFromSource(DateTime date, String source) async {
    final entries = await getDailyCalories(date);
    final newEntry = entries
        .where((e) => e.source?.startsWith(source) ?? false)
        .fold(0, (sum, e) => sum + e.calories);
    return newEntry;
  }

  Future<int> getDailyStepsCalories(DateTime date) async {
    return await getDailyCaloriesFromSource(date, 'steps');
  }

  Future<int> getDailyWorkoutCalories(DateTime date) async {
    return await getDailyCaloriesFromSource(date, 'workout');
  }

  Future<int> getCalorieForDay(DateTime date, {required int steps}) async {
    final base = await getDailyTotal(date);
    final workout = await getDailyWorkoutCalories(date);
    final stepCal = isToday(date) ? calculateStepsCalories(steps) : 0;
    return base + workout + stepCal;
  }

  Future<void> clearCaloriesByDay(DateTime date) async {
    final box = await _calorieBox;
    final entries = await getDailyCalories(date);
    for (var entry in entries) {
      final idx = box.values.toList().indexOf(entry);
      if (idx != -1) await box.deleteAt(idx);
    }
  }

  Future<List<CaloryState>> getAllEntries() async {
    final box = await _calorieBox;
    return box.values.toList();
  }
}
