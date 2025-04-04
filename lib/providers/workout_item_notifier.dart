import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/models/workout/workout.dart';
import 'package:workout_tracker/services/workout_service.dart';
import 'package:workout_tracker/utils/alerts.dart';
import 'package:workout_tracker/views/pages/workouts/widgets/add_workout_container.dart';

class WorkoutItemNotifier extends StateNotifier<List<Workout>> {
  WorkoutItemNotifier() : super([]);

  final ws = WorkoutService();

  final _nameController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _descController = TextEditingController();
  final _goalRepsController = TextEditingController();
  final _goalDurationController = TextEditingController();

  TextEditingController get nameController => _nameController;
  TextEditingController get setsController => _setsController;
  TextEditingController get repsController => _repsController;
  TextEditingController get descController => _descController;
  TextEditingController get goalRepsController => _goalRepsController;
  TextEditingController get goalDurationController => _goalDurationController;

  Future<void> getWorkouts() async {
    debugPrint('Getting workouts...');
    final newWorkouts = await ws.getWorkouts();
    state = newWorkouts; // Update the state with the fetched list
    debugPrint('Workouts: ${state.length}');
  }

  void addWorkout(BuildContext context) {
    debugPrint('Adding workout...');
    if (_nameController.text.isEmpty || _setsController.text.isEmpty || _repsController.text.isEmpty || _goalDurationController.text.isEmpty) {
      debugPrint('Error adding workout: Empty fields');
      Alerts.showErrorDialog(context, 'Empty text field', 'Please fill all required fields to continue');
      return;
    }
    debugPrint('Goal duration controller text from Notifier: ${_goalDurationController.text}');
    try {
      final newWorkout = Workout(
        name: _nameController.text,
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
      builder: (context) => AddWorkoutContainer(),
    );
  }

  // Optional: Clear controllers method
  void clearControllers() {
    _nameController.clear();
    _setsController.clear();
    _repsController.clear();
    _descController.clear();
    _goalRepsController.clear();
    _goalDurationController.clear();
  }
}

// Updated provider declaration
final workoutItemProvider = StateNotifierProvider<WorkoutItemNotifier, List<Workout>>((ref) => WorkoutItemNotifier());