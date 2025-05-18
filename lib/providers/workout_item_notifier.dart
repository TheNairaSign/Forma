// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/models/workout/workout.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';
import 'package:workout_tracker/services/workout_service.dart';
import 'package:workout_tracker/utils/alerts.dart';

class WorkoutItemNotifier extends StateNotifier<List<Workout>> {
  final Ref ref;
  WorkoutItemNotifier(this.ref) : super([]);

  final ws = WorkoutService();

  final List<DayActivity> _workoutForDay = List.filled(7, DayActivity(
    name: 'Rest Day',
    steps: 0,
    isRestDay: true
  ));
  List<DayActivity> get workoutForDay => _workoutForDay;

  Future<void> getWorkoutsForDay(DateTime date) async {
    final _stepsNotifier = ref.read(stepsProvider.notifier);
    debugPrint('Getting workouts for ${date.toString()}...');
    final newWorkouts = await ws.getWorkoutsForDay(date);
    final weekDayIndex = date.weekday - 1;
    final stepsForDate = _stepsNotifier.getStepsForDate(date) ?? 0;
    
    if (stepsForDate == 0 && newWorkouts.isEmpty) {
      _workoutForDay[weekDayIndex] = DayActivity(
        name: 'Rest Day',
        steps: 0,
        isRestDay: true
      );
    } else if (newWorkouts.isNotEmpty && stepsForDate == 0) {
      final workout = newWorkouts.first;
      _workoutForDay[weekDayIndex] = DayActivity(
        name: workout.name,
        steps: 0,
        sets: workout.sets,
        reps: workout.reps,
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
        sets: workout.sets,
        reps: workout.reps,
        goalDuration: workout.goalDuration,
        isRestDay: false
      );
    }
    debugPrint('Workouts for day: ${newWorkouts.length}');
  }

  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _descController = TextEditingController();
  final _goalRepsController = TextEditingController();
  final _goalDurationController = TextEditingController();

  TextEditingController get setsController => _setsController;
  TextEditingController get repsController => _repsController;
  TextEditingController get descController => _descController;
  TextEditingController get goalRepsController => _goalRepsController;
  TextEditingController get goalDurationController => _goalDurationController;


  String _workoutName = '';
  set workoutNameValue(String value) => _workoutName = value;  

  Future<void> getWorkouts() async {
    debugPrint('Getting workouts...');
    final newWorkouts = await ws.getWorkouts();
    state = newWorkouts;
    debugPrint('Workouts: ${state.length}');
  }

  void addWorkout(BuildContext context) {
    debugPrint('Adding workout...');
    if (_workoutName.isEmpty || _setsController.text.isEmpty || _repsController.text.isEmpty || _goalDurationController.text.isEmpty) {
      debugPrint('Error adding workout: Empty fields');
      Alerts.showErrorDialog(context, 'Empty text field', 'Please fill all required fields to continue');
      return;
    }
    debugPrint('Goal duration controller text from Notifier: ${_goalDurationController.text}');
    try {
      final newWorkout = Workout(
        name: _workoutName[0].toUpperCase() + _workoutName.substring(1),
        sets: int.parse(_setsController.text),
        reps: int.parse(_repsController.text),
        goalReps: _goalRepsController.text.isNotEmpty
            ? int.parse(_goalRepsController.text)
            : null,
        goalDuration: _goalDurationController.text.isNotEmpty
            ? int.parse(_goalDurationController.text)
            : null,
        description: _descController.text.isNotEmpty ? _descController.text : null, // Assuming Workout has a description field
      );
      state = [...state, newWorkout];
      ws.addWorkout(newWorkout).then((value) {
        try {
        debugPrint('Workout added: ${newWorkout.name}');
        getWorkouts();
        } catch (e) {
          debugPrint('Error adding workout: ${e.toString()}'); 
        }
        Navigator.of(context).pop();
      });

      debugPrint('Workout added: ${newWorkout.name}');
      // getWorkouts();
      // Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Error adding workout: ${e.toString()}');
    } finally {
      clearControllers();
    }
  }

  /*
  void showAddWorkoutModal(BuildContext context) {
    showModalBottomSheet(
      sheetAnimationStyle: AnimationStyle(curve: Curves.easeIn, duration: Duration(milliseconds: 500)),
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddWorkoutContainer(),
      ),
    );
  }
  */

  // Optional: Clear controllers method
  void clearControllers() {
    _setsController.clear();
    _repsController.clear();
    _descController.clear();
    _goalRepsController.clear();
    _goalDurationController.clear();
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