// lib/services/workout_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:workout_tracker/models/workout/workout.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';

class WorkoutService {
  final String? userId;
  WorkoutService({this.userId});

  Box<Workout> get _workoutBox => Hive.box<Workout>('workouts_$userId');
  Box<Workout> get _historyBox => Hive.box<Workout>('workout_history_$userId');

  Future<void> saveWorkouts(List<Workout> workouts) async {
    await _workoutBox.clear();
    for (var workout in workouts) {
      await _workoutBox.put(workout.id, workout); 
    }
  }

  Future<void> saveToHistory(Workout workout) async {
    await _historyBox.put(workout.id, workout);
  }


  Future<List<Workout>> getWorkouts() async {
    return _workoutBox.values.toList();
  }

  Future<List<Workout>> getWorkoutsForDay(DateTime date) async {
    return _workoutBox.values
        .where((w) => w.sessions.any(
              (s) =>
                  s.timestamp.year == date.year &&
                  s.timestamp.month == date.month &&
                  s.timestamp.day == date.day,
            ))
        .toList();
  }

  Future<void> addWorkout(Workout workout) async {
    try {
      await _workoutBox.put(workout.id, workout);
      // Create a copy for the history box to avoid HiveError
      final historyWorkout = Workout.fromMap(workout.toMap());
      await saveToHistory(historyWorkout);
    } catch (e) {
      debugPrint('Error adding workout: $e');
      rethrow;
    }
  }

  Future<int> getTotalWorkoutsCount() async {
    debugPrint('Getting overall total workout count...');
    return _historyBox.length;
  }

  Future<Map<String, int>> getWorkoutStatistics() async {
    debugPrint('Getting workout stats...');
    final workouts = await getWorkouts();
    return {
      'overallWorkouts': await getTotalWorkoutsCount(),
      'totalWorkouts': workouts.length,
      'totalSessions': workouts.fold(0, (sum, w) => sum + w.sessions.length),
      'activeWorkouts': workouts.where((w) => w.isActive).length,
    };
  }

  Future<void> deleteWorkout(String workoutId) async {
    await _workoutBox.delete(workoutId);
  }

  Future<void> clearWorkouts({DateTime? date}) async {
    if (date == null) {
      await _workoutBox.clear();
      return;
    }

    final workouts = await getWorkouts();
    workouts.removeWhere((workout) => workout.sessions.any(
          (session) =>
              session.timestamp.year == date.year &&
              session.timestamp.month == date.month &&
              session.timestamp.day == date.day,
        ));

    await saveWorkouts(workouts);
  }

  Future<List<Workout>> getHistory() async {
    debugPrint('Getting history...');
    return _historyBox.values.toList();
  }

  Future<void> pruneWorkoutHistory({required Duration maxAge}) async {
    final cutoffDate = DateTime.now().subtract(maxAge);
    final history = await getHistory();
    for (var workout in history) {
      if (workout.sessions.any((session) => session.timestamp.isBefore(cutoffDate))) {
        await _historyBox.delete(workout.id);
      }
    }
  }

  Future<bool> undoDelete(String workoutId, WidgetRef ref) async {
    final workout = _historyBox.get(workoutId);
    if (workout == null) return false;

    if (_workoutBox.containsKey(workoutId)) return false;

    await _workoutBox.put(workoutId, workout);
    ref.watch(workoutItemProvider.notifier).getWorkouts();
    return true;
  }
}
