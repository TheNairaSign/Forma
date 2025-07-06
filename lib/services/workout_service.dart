// lib/services/workout_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_tracker/models/workout/workout.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';

class WorkoutService {
  static const _workoutKey = 'workouts';
  static const _allWorkoutsKey = 'all_workouts_history';

  Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  Future<void> saveWorkouts(List<Workout> workouts) async {
    final jsonString = jsonEncode(workouts.map((w) => w.toMap()).toList());
    await (await _prefs()).setString(_workoutKey, jsonString);
  }

  Future<void> saveToHistory(Workout workout) async {
    final prefs = await _prefs();
    final history = await _getHistory();
    history.add(workout.toMap());
    await prefs.setString(_allWorkoutsKey, jsonEncode(history));
  }

  Future<List<Workout>> getWorkouts() async {
    final jsonString = (await _prefs()).getString(_workoutKey);
    if (jsonString == null) return [];
    return (jsonDecode(jsonString) as List).map((map) => Workout.fromMap(map)).toList();
  }

  Future<List<Workout>> getWorkoutsForDay(DateTime date) async {
    return (await getWorkouts()).where((w) => w.sessions.any(
          (s) =>
              s.timestamp.year == date.year &&
              s.timestamp.month == date.month &&
              s.timestamp.day == date.day,
        )).toList();
  }

  Future<void> addWorkout(Workout workout) async {
    try {
      final workouts = await getWorkouts();
      workouts.add(workout);
      await Future.wait([
        saveWorkouts(workouts),
        saveToHistory(workout),
      ]);
    } catch (e) {
      debugPrint('Error adding workout: $e');
      rethrow;
    }
  }

  Future<int> getTotalWorkoutsCount() async {
    return (await _getHistory()).length;
  }

  Future<Map<String, int>> getWorkoutStatistics() async {
    final workouts = await getWorkouts();
    return {
      'overallWorkouts': await getTotalWorkoutsCount(),
      'totalWorkouts': workouts.length,
      'totalSessions': workouts.fold(0, (sum, w) => sum + w.sessions.length),
      'activeWorkouts': workouts.where((w) => w.isActive).length,
    };
  }

  Future<void> deleteWorkout(String workoutId) async {
    final workouts = await getWorkouts();
    workouts.removeWhere((w) => w.id == workoutId);
    await saveWorkouts(workouts);
  }

  Future<void> clearWorkouts({DateTime? date}) async {
    if (date == null) {
      // Clear all workouts if no date specified
      await (await _prefs()).setString(_workoutKey, jsonEncode([]));
      return;
    }

    // Get existing workouts
    final workouts = await getWorkouts();
    
    // Remove workouts for the specified date
    workouts.removeWhere((workout) => workout.sessions.any(
      (session) => 
        session.timestamp.year == date.year &&
        session.timestamp.month == date.month &&
        session.timestamp.day == date.day
    ));

    // Save filtered workouts
    await saveWorkouts(workouts);
  }

  Future<List<dynamic>> _getHistory() async {
    final jsonString = (await _prefs()).getString(_allWorkoutsKey);
    return jsonString != null ? jsonDecode(jsonString) as List : [];
  }

  Future<void> pruneWorkoutHistory({required Duration maxAge}) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_allWorkoutsKey);
    if (jsonString == null) return;

    final cutoffDate = DateTime.now().subtract(maxAge);
    final workoutMaps = jsonDecode(jsonString) as List;
    final filteredMaps = workoutMaps.where((map) {
      final workout = Workout.fromMap(map);
      return workout.sessions.any((session) => session.timestamp.isAfter(cutoffDate));
    }).toList();

    await prefs.setString(_allWorkoutsKey, jsonEncode(filteredMaps));
  }

  Future<bool> undoDelete(String workoutId, WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_allWorkoutsKey);
    if (historyJson == null) return false;
    
    final historyMaps = jsonDecode(historyJson) as List;
    final workoutMap = historyMaps.cast<Map<String, dynamic>>().firstWhere((w) => w['id'] == workoutId);
    
    if (workoutMap['id'] == null) return false;
    
    final workout = Workout.fromMap(workoutMap);
    final workouts = await getWorkouts();
    
    if (workouts.any((w) => w.id == workoutId)) return false;
    
    workouts.insert(0, workout);
    await saveWorkouts(workouts);
    ref.watch(workoutItemProvider.notifier).getWorkouts();
    return true;
  }

}