// lib/services/workout_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_tracker/models/workout/workout.dart';

class WorkoutService {
  final String _workoutKey = 'workouts';

  // Workouts
  Future<void> saveWorkouts(List<Workout> workouts) async {
    final prefs = await SharedPreferences.getInstance();
    final workoutMaps = workouts.map((workout) => workout.toMap()).toList();
    final jsonString = jsonEncode(workoutMaps);
    await prefs.setString(_workoutKey, jsonString);
  }

  Future<List<Workout>> getWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_workoutKey);
    if (jsonString == null) return [];
    final workoutMaps = jsonDecode(jsonString) as List;
    return workoutMaps.map((map) => Workout.fromMap(map)).toList();
  }

  Future<void> addWorkout(Workout workout) async {
    debugPrint('Adding workout: ${workout.name}');
    final workouts = await getWorkouts();
    try {
      workouts.add(workout);
    } catch (e) {
      debugPrint('Error adding workout: ${e.toString()}');
    }
    await saveWorkouts(workouts);
  }

  Future<void> updateWorkout(Workout updatedWorkout) async {
    final workouts = await getWorkouts();
    final index = workouts.indexWhere((workout) => workout.id == updatedWorkout.id);
    if (index != -1) {
      workouts[index] = updatedWorkout;
      await saveWorkouts(workouts);
    }
  }

  Future<void> deleteWorkout(String id) async {
    final workouts = await getWorkouts();
    workouts.removeWhere((workout) => workout.id == id);
    await saveWorkouts(workouts); 
  }

  Future <void> clearWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_workoutKey); 
  }
}