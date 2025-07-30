// lib/services/workout_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:workout_tracker/models/workout/workout.dart';
import 'package:workout_tracker/providers/box_providers.dart';

class WorkoutService {
  final Box<Workout> _workoutBox;
  final Box<Workout> _historyBox;

  WorkoutService(this._workoutBox, this._historyBox);

  void saveWorkouts(List<Workout> workouts) async {
    _workoutBox.clear();
    for (var workout in workouts) {
      await _workoutBox.put(workout.id, workout); 
    }
  }

  void saveToHistory(Workout workout) async {
    await _historyBox.put(workout.id, workout);
  }

  List<Workout> getWorkouts() {
    return _workoutBox.values.toList();
  }

  List<Workout> getWorkoutsForDay(DateTime date) {
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
      saveToHistory(historyWorkout);
    } catch (e) {
      debugPrint('Error adding workout: $e');
      rethrow;
    }
  }

  int getTotalWorkoutsCount() {
    debugPrint('Getting overall total workout count...');
    return _historyBox.length;
  }

  Map<String, int> getWorkoutStatistics() {
    debugPrint('Getting workout stats...');
    final workouts = getWorkouts();
    return {
      'overallWorkouts': getTotalWorkoutsCount(),
      'totalWorkouts': workouts.length,
      'totalSessions': workouts.fold(0, (sum, w) => sum + w.sessions.length),
      'activeWorkouts': workouts.where((w) => w.isActive).length,
    };
  }

  void deleteWorkout(String workoutId) {
    _workoutBox.delete(workoutId);
  }

  void clearWorkouts({DateTime? date}) {
    if (date == null) {
      _workoutBox.clear();
      return;
    }

    final workouts = getWorkouts();
    workouts.removeWhere((workout) => workout.sessions.any(
          (session) =>
              session.timestamp.year == date.year &&
              session.timestamp.month == date.month &&
              session.timestamp.day == date.day,
        ));

    saveWorkouts(workouts);
  }

  List<Workout> getHistory() {
    debugPrint('Getting history...');
    return _historyBox.values.toList();
  }

  void pruneWorkoutHistory({required Duration maxAge}) {
    final cutoffDate = DateTime.now().subtract(maxAge);
    final history = getHistory();
    for (var workout in history) {
      if (workout.sessions.any((session) => session.timestamp.isBefore(cutoffDate))) {
        _historyBox.delete(workout.id);
      }
    }
  }

  Future<bool> undoDelete(String workoutId) async {
    final workout = _historyBox.get(workoutId);
    if (workout == null) return false;

    if (_workoutBox.containsKey(workoutId)) return false;

    await _workoutBox.put(workoutId, workout);
    return true;
  }
}


final workoutServiceProvider = Provider<WorkoutService>((ref) {
  final workoutBox = ref.watch(workoutBoxProvider);
  final historyBox = ref.watch(workoutHistoryBoxProvider);
  return WorkoutService(workoutBox, historyBox);
});
