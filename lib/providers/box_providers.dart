// lib/providers/hive_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:workout_tracker/hive/adapter/calory_state.dart';
import 'package:workout_tracker/hive/daily_steps_adapter.dart';
import 'package:workout_tracker/hive/hourly_steps.dart';
import 'package:workout_tracker/models/state/profile_data.dart';
import 'package:workout_tracker/models/workout/workout.dart';


final userProfileBoxProvider = Provider<Box<ProfileData>>((ref) {
  final userProfileBox = Hive.box<ProfileData>('newUser');
  print('Accessing box: ${userProfileBox.name}, isOpen: ${userProfileBox.isOpen}');
  return userProfileBox;
});

final workoutBoxProvider = Provider<Box<Workout>>((ref) {
  final workoutBox = Hive.box<Workout>('workouts_');
  print('Accessing box: ${workoutBox.name}, isOpen: ${workoutBox.isOpen}');
  return workoutBox;
});

final workoutHistoryBoxProvider = Provider<Box<Workout>>((ref) {
  final workoutHistoryBox = Hive.box<Workout>('workout_history_');
  print('Accessing box: ${workoutHistoryBox.name}, isOpen: ${workoutHistoryBox.isOpen}');
  return workoutHistoryBox;
});

final stepsBoxProvider = Provider<Box<DailySteps>>((ref) {
  final stepsBox = Hive.box<DailySteps>('stepsDaily');
  print('Accessing box: ${stepsBox.name}, isOpen: ${stepsBox.isOpen}');
  return stepsBox;
});

final caloriesBoxProvider = Provider<Box<CaloryState>>((ref) {
  final calorieBox = Hive.box<CaloryState>('calorieBox_');
  print('Accessing box: ${calorieBox.name}, isOpen: ${calorieBox.isOpen}');
  return calorieBox;
});

final hourlyStepsBoxProvider = Provider<Box<HourlySteps>>((ref) {
  final hourlyStepsBox = Hive.box<HourlySteps>('hourlySteps');
  print('Accessing box: ${hourlyStepsBox.name}, isOpen: ${hourlyStepsBox.isOpen}');
  return hourlyStepsBox;
});
