import 'package:hive/hive.dart';
import 'package:workout_tracker/hive/daily_steps_adapter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class StepsProgressNotifier extends StateNotifier<DailySteps> {
  final Ref ref;
  StepsProgressNotifier(this.ref) : super(DailySteps(date: DateTime.now(), steps: 0, lastUpdated: DateTime.now(),),) {
    _initializeState();
  }

  // final Box<DailySteps> _dailyStepsBox = Hive.box<DailySteps>('dailyStepsBox');

  Box<DailySteps> get _dailyStepsBox => Hive.box<DailySteps>('dailySteps');
  
  String _getDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void _initializeState() {
    final today = _getDateKey(DateTime.now());
    final dailySteps = _dailyStepsBox.get(today);
    if (dailySteps != null) {
      state = dailySteps;
    }
  }

  Future<void> updateSteps(int steps) async {
    final dateKey = _getDateKey(DateTime.now());
    final newState = DailySteps(
      date: DateTime.now(),
      steps: steps,
      lastUpdated: DateTime.now(),
    );
    
    await _dailyStepsBox.put(dateKey, newState);
    state = newState;
  }

  int getStepsForDate(DateTime date) {
    final dateKey = _getDateKey(date);
    return _dailyStepsBox.get(dateKey)?.steps ?? 0;
  }

  List<DailySteps> getStepsHistory({int days = 7}) {
    final now = DateTime.now();
    final List<DailySteps> history = [];
    
    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));
      final dateKey = _getDateKey(date);
      final steps = _dailyStepsBox.get(dateKey) ?? 
        DailySteps(date: date, steps: 0, lastUpdated: date);
      history.add(steps);
    }
    
    return history;
  }

  double getProgressPercentage({int dailyGoal = 10000}) {
    return (state.steps / dailyGoal).clamp(0.0, 1.0);
  }
}

final stepsProgressProvider = StateNotifierProvider<StepsProgressNotifier, DailySteps>((ref) {
  return StepsProgressNotifier(ref);
});