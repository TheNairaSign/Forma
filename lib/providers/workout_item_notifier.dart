// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/models/enums/workout_group.dart';
import 'package:workout_tracker/models/enums/workout_type.dart';
import 'package:workout_tracker/models/workout/workout.dart';
import 'package:workout_tracker/providers/calories_provider.dart';
import 'package:workout_tracker/providers/progress_provider.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';
import 'package:workout_tracker/providers/workout_group_notifier.dart';
import 'package:workout_tracker/services/workout_service.dart';
import 'package:workout_tracker/utils/alerts.dart';
import 'package:workout_tracker/views/pages/workouts/sub_pages/add_workout_page.dart';

class WorkoutItemNotifier extends AsyncNotifier<List<Workout>> {
  // final Ref ref;
  late WorkoutService _service;

  // WorkoutItemNotifier(this.ref) : super([]){
  //   getWorkouts();
  // }

  @override
  Future<List<Workout>> build() async {
    _service = ref.read(workoutServiceProvider);
    final workouts = _service.getWorkouts();
    return workouts;
  }

  WorkoutGroup? _workoutGroup;
  WorkoutGroup? get workoutGroup => _workoutGroup;

  WorkoutService get ws => ref.watch(workoutServiceProvider);


  String _workoutName = 'Arms';
  set workoutNameValue(String value) {
    if (_workoutName != value) {
      _workoutName = value;
      // state = [...state];
      // state =  AsyncValue.data(state);
    }
    debugPrint('Workout name changed to $value');
  }
  String get workoutName => _workoutName;

  final List<String> workoutIntensity = [
    'Light', 
    'Moderate',
    'High',
    'Very High'
  ];

  double getMETByIntensity(String? intensity) {
    switch (intensity?.toLowerCase()) {
      case 'high':
        return 8.0;
      case 'moderate':
      case 'medium':
        return 6.0;
      case 'low':
        return 3.5;
      default:
        return 5.0; // average
    }
  }


  WorkoutType _selectedWorkoutType = WorkoutType.arms;
  
  set selectedWorkoutType(WorkoutType value) {
    // if (_selectedWorkoutType != value) {
      _selectedWorkoutType = value;
      _workoutGroup = workoutGroupMap[value];
      // state = [...state];
      debugPrint('Workout type changed to: $value, group: ${workoutGroupMap[value]}');
    // }
  }
  WorkoutType get selectedWorkoutTypeGetter => _selectedWorkoutType;

  final List<DayActivity> _workoutForDay = List.filled(7, DayActivity(
    name: 'Rest Day',
    steps: 0,
    isRestDay: true
  ));
  List<DayActivity> get workoutForDay => _workoutForDay;

  String getWorkoutStats() {
    final workoutStats = ws.getWorkoutStatistics();
    return workoutStats['overallWorkouts'].toString();
  }

  Future<List<DayActivity>> getWorkoutsForDay(DateTime date) async {
    debugPrint('Getting workouts for ${date.toString()}...');
    final newWorkouts = ws.getWorkoutsForDay(date);
    final weekDayIndex = date.weekday - 1;
    final stepsForDate = ref.read(stepsProvider.notifier).getStepsForDate(date) ?? 0;
    debugPrint('Workouts for date: ${workoutForDay.length}');

    for (var workout in workoutForDay) {
      debugPrint(workout.name);
    }

    DayActivity dayActivity;
    if (newWorkouts.isEmpty) {
      dayActivity = DayActivity(
        name: stepsForDate > 0 ? 'Steps only' : 'Rest Day',
        steps: stepsForDate,
        isRestDay: stepsForDate == 0,
      );
    } else {
      final workout = newWorkouts.first;
      dayActivity = DayActivity(
        name: stepsForDate > 0 ? '${workout.name}, $stepsForDate steps' : workout.name,
        steps: stepsForDate,
        sets: workout.sets ?? 0,
        reps: workout.reps ?? 0,
        goalDuration: workout.goalDuration,
        isRestDay: false,
      );
    }

    _workoutForDay[weekDayIndex] = dayActivity;
    debugPrint('Workouts for day: ${newWorkouts.length}');
    state = AsyncValue.data(newWorkouts);
    return _workoutForDay;
  }

  void getWorkouts() async {
    debugPrint('Getting workouts...');
    final newWorkouts = ws.getWorkouts();
    state = AsyncValue.data(newWorkouts);
    debugPrint('Workouts: ${state.value?.length}');
  } 

  void clearWorkouts(BuildContext? context, DateTime? date, {bool showAlert = true}) {
    debugPrint('Clearing workouts...');
    ws.clearWorkouts(date: date ?? DateTime.now());
    // CalorieService().clearCaloriesByDay(date ?? DateTime.now());
    state = AsyncValue.data([]);
    if (showAlert && context != null) {
      Alerts.showFlushBar(context, 'Workouts cleared', false);
    }
  }

  void validateAllForms(BuildContext context) {
    final workoutGroupProvider = Provider.of<WorkoutGroupNotifier>(context, listen: false);
    if (workoutGroupProvider.validateCardioForm() || 
        workoutGroupProvider.validateFlowForm() || 
        workoutGroupProvider.validateRepetitionForm() || 
        workoutGroupProvider.validateStrengthForm() || 
        workoutGroupProvider.validateTimeForm()) {
      // Alerts.showErrorDialog(context, 'Empty text field', 'Please fill all required fields to continue');
      return;
    }
  }

  void addWorkout(BuildContext context, Workout newWorkout, WorkoutGroup group) async {
    debugPrint('Adding workout: $newWorkout');
    validateAllForms(context);
    state = AsyncValue.loading();

    // Optimistically update the state for a responsive UI
    // state = [...state, newWorkout];

    try {
      await ws.addWorkout(newWorkout);
      final workouts = ws.getWorkouts();

      state = AsyncValue.data(workouts);

      // If the API call is successful, calculate calories.
      try {
        ref.watch(caloriesProvider.notifier).calculateCalories(
          group: group,
          name: newWorkout.name,
          durationSeconds: newWorkout.durationInSeconds,
          weightKg: newWorkout.weight,
          sets: newWorkout.sets,
          reps: newWorkout.reps,
        );
        
        // Show dialog after calories are calculated
        showDialog(context: context, builder: (context) {
          final calories = ref.watch(caloriesProvider.notifier).caloriesAdded;
          return SizedBox(
            height: 150,
            child: AlertDialog(
              title: Text('Congrats, you just burnt $calories calories!'),
              content: LottieBuilder.asset('assets/lottie/check-animation.json', repeat: false),
            ),
          );
        });
        
        debugPrint('New workout details: $group, ${newWorkout.name}, ${newWorkout.durationInSeconds}, ${newWorkout.sets}, ${newWorkout.reps}, ${newWorkout.weight} ');
      } catch (e) {
        debugPrint('Error calculating calories for workout: ${e.toString()}');
      }

      // Show confirmation and then pop the screen.
      debugPrint('Workout added successfully: ${newWorkout.name}');
      if (context.mounted) {
        // Alerts.showFlushBar(context, 'Workout added', false);
        
        // Schedule the pop for after the build phase to avoid the debug lock.
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   if(context.mounted) Navigator.of(context).pop();
        // });
      }

    } catch (e) {
      debugPrint('Error adding workout: ${e.toString()}');

      // If the API call fails, roll back the optimistic state update.
      final workouts = ws.getWorkouts();
      workouts.where((w) => w != newWorkout).toList();
      state = AsyncValue.data(workouts);
      
      // Notify the user of the error.
      if (context.mounted) Alerts.showFlushBar(context, 'Failed to add workout', true);
    }
  }

  void deleteWorkout(Workout workout) {
    ws.deleteWorkout(workout.id);
    getWorkouts();
  }

  void undoDelete(BuildContext context, String id) async {
    final success = await ws.undoDelete(id);
    // if (mounted) {
      if (success == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout restored successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not restore workout')),
        );
      }
    // }
    ref.watch(workoutItemProvider.notifier).getWorkouts();
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

  double get workoutProgress {
    final progress = ref.watch(progressProvider.notifier).calculateProgress(state.value?.length ?? 0, 10);
    return progress.toDouble();
  }
}

// Updated provider declaration
final workoutItemProvider = AsyncNotifierProvider<WorkoutItemNotifier, List<Workout>>(() {
  return WorkoutItemNotifier();
});

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