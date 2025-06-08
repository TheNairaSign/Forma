// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:provider/provider.dart';
import 'package:workout_tracker/models/enums/workout_group.dart';
import 'package:workout_tracker/models/enums/workout_type.dart';
import 'package:workout_tracker/models/workout/workout.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';
import 'package:workout_tracker/providers/workout_group_notifier.dart';
import 'package:workout_tracker/services/workout_service.dart';
import 'package:workout_tracker/utils/alerts.dart';
import 'package:workout_tracker/views/pages/workouts/sub_pages/add_workout_page.dart';

class WorkoutItemNotifier extends StateNotifier<List<Workout>> {
  final Ref ref;
  WorkoutItemNotifier(this.ref) : super([]);

  final ws = WorkoutService();

  WorkoutGroup? _workoutGroup;
  WorkoutGroup? get workoutGroup => _workoutGroup;

  String _workoutName = '';
  set workoutNameValue(String value) {
    if (_workoutName != value) {
      _workoutName = value;
      state = [...state];
    }
    debugPrint('Workout name changed to $value');
  }
  String get workoutName => _workoutName;

  WorkoutType _selectedWorkoutType = WorkoutType.arms;  // Set default type
set selectedWorkoutType(WorkoutType value) {
    if (_selectedWorkoutType != value) {
      _selectedWorkoutType = value;
      _workoutGroup = workoutGroupMap[value];
      state = [...state]; // Trigger state update
      debugPrint('Workout type changed to: $value, group: ${workoutGroupMap[value]}');
    }
  }
  WorkoutType get selectedWorkoutTypeGetter => _selectedWorkoutType;

  final List<DayActivity> _workoutForDay = List.filled(7, DayActivity(
    name: 'Rest Day',
    steps: 0,
    isRestDay: true
  ));
  List<DayActivity> get workoutForDay => _workoutForDay;

  Future<List<DayActivity>> getWorkoutsForDay(DateTime date) async {
    debugPrint('Getting workouts for ${date.toString()}...');
    final newWorkouts = await ws.getWorkoutsForDay(date);
    final weekDayIndex = date.weekday - 1;
    final stepsForDate = ref.read(stepsProvider.notifier).getStepsForDate(date) ?? 0;
    
    if (stepsForDate == 0 && newWorkouts.isEmpty) {
      _workoutForDay[weekDayIndex] = DayActivity(
        name: 'Rest Day',
        steps: stepsForDate, 
        isRestDay: true
      );
    } else if (newWorkouts.isNotEmpty && stepsForDate == 0) {
      final workout = newWorkouts.first;
      _workoutForDay[weekDayIndex] = DayActivity(
        name: workout.name,
        steps: stepsForDate,
        sets: workout.sets!,
        reps: workout.reps!,
        goalDuration: workout.goalDuration,
        isRestDay: false
      );
    } else if (stepsForDate > 0 && newWorkouts.isEmpty) {
      _workoutForDay[weekDayIndex] = DayActivity(
        name: 'Steps only',
        steps: stepsForDate,
        isRestDay: false
      );
    } else {
      final workout = newWorkouts.first;
      _workoutForDay[weekDayIndex] = DayActivity(
        name: '${workout.name}, $stepsForDate steps',
        steps: stepsForDate,
        sets: workout.sets!,
        reps: workout.reps!,
        goalDuration: workout.goalDuration,
        isRestDay: false
      );
    }
    debugPrint('Workouts for day: ${newWorkouts.length}');
    return _workoutForDay;
  }

  Future<void> getWorkouts() async {
    debugPrint('Getting workouts...');
    final newWorkouts = await ws.getWorkouts();
    state = newWorkouts;
    debugPrint('Workouts: ${state.length}');
  } 

  void clearWorkouts(BuildContext context) {
    debugPrint('Clearing workouts...');
    state = [];
    Alerts.showFlushBar(context, 'Workouts cleared', false);
  }

  void validateAllForms(BuildContext context) {
    final workoutGroupProvider = Provider.of<WorkoutGroupNotifier>(context, listen: false);
    if (workoutGroupProvider.validateCardioForm() || 
        workoutGroupProvider.validateFlowForm() || 
        workoutGroupProvider.validateRepetitionForm() || 
        workoutGroupProvider.validateStrengthForm() || 
        workoutGroupProvider.validateTimeForm()) {
      Alerts.showErrorDialog(context, 'Empty text field', 'Please fill all required fields to continue');
      return;
    }
  }

  void addWorkout(BuildContext context, Workout newWorkout)  {
    debugPrint('Adding workout...');
    debugPrint('$newWorkout');
    validateAllForms(context);
    try {
      state = [...state, newWorkout];
      ws.addWorkout(newWorkout).then((value) {
        // try {
        debugPrint('Workout added: ${newWorkout.name}');
        // try {
        //   ref.watch(caloryProvider.notifier).addWorkoutCalories(
        //     workoutName: _workoutName,
        //     durationMinutes: newWorkout.goalDuration!,
        //     metValue: WorkoutType.values.firstWhere(
        //       (element) => element.name.toLowerCase() == _workoutName.toLowerCase(),
        //       orElse: () => WorkoutType.strength, // Provide a default type
        //     ).MET,
        //   );
        // } catch (e) {
        //   debugPrint('Error adding workout calories: ${e.toString()}');
        // }
        getWorkouts();
        // } catch (e) {
        //   debugPrint('Error adding workout: ${e.toString()}'); 
        // }
        Navigator.of(context).pop();
      });

      debugPrint('Workout added: ${newWorkout.name}');
      // getWorkouts();
      // Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Error adding workout: ${e.toString()}');
    }
  }

  
  void showAddWorkoutModal(BuildContext context) {
    showModalBottomSheet(
      sheetAnimationStyle: AnimationStyle(curve: Curves.easeIn, duration: Duration(milliseconds: 500)),
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddWorkoutPage(),
      ),
    );
  }
}

// Updated provider declaration
final workoutItemProvider = StateNotifierProvider<WorkoutItemNotifier, List<Workout>>((ref) => WorkoutItemNotifier(ref));

class DayActivity {
  final String name;
  final int steps;
  final int sets;
  final int reps;
  final int? goalDuration;
  final bool isRestDay;

  DayActivity({
    required this.name,
    this.steps = 0,
    this.sets = 0,
    this.reps = 0,
    this.goalDuration,
    this.isRestDay = true,
  });
}