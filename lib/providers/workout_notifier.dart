import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/models/workout/workout.dart';
import 'package:workout_tracker/models/workout/workout_session.dart';
import 'package:workout_tracker/services/workout_service.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';

class WorkoutNotifier extends StateNotifier<Workout> {
  WorkoutNotifier(this.ref, Workout workout) : super(workout);
  final Ref ref;
  final WorkoutService _workoutService = WorkoutService();

  // For pause/resume and stopwatch
  int? _elapsedSeconds;
  int? get elapsedSeconds => _elapsedSeconds;

  Timer? _timer;
  
  bool _isPaused = true;
  bool get isPaused => _isPaused;

  List<int> _setsCompleted = [];
  List<int> get setsCompleted => _setsCompleted;
  void initState(int index) {
    final goalDuration = ref.watch(workoutItemProvider)[index].goalDuration;
    _setsCompleted = List.filled(state.sets, 0);
    _elapsedSeconds = goalDuration;
  }

  void startWorkout(int index) {
    if (_timer == null || !_timer!.isActive) {
      _isPaused = false;
      state = state.copyWith(isActive: true);

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_elapsedSeconds! > 0) {
          _elapsedSeconds = _elapsedSeconds! - 1;
        } else {
          timer.cancel();
          _isPaused = true;
        }
        // Notify listeners of the change
        state = state.copyWith();
      });
    }
  }

  void pauseWorkout() {
    debugPrint('Workout paused');
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _isPaused = true;
    }
  }

  void resumeWorkout(int goalDuration) {
    debugPrint('Workout resumed');
    if (_isPaused) startWorkout(goalDuration);
  }

  void stopWorkout(BuildContext context) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _isPaused = true;
    state = state.copyWith(
      isActive: false,
      durationInSeconds: state.durationInSeconds + (_elapsedSeconds ?? 0),
      sessions: [...state.sessions, WorkoutSession(
        timestamp: DateTime.now(),
        durationInSeconds: _elapsedSeconds!,
        setsCompleted: _setsCompleted.where((reps) => reps > 0).length,
        repsCompleted: _setsCompleted.reduce((a, b) => a + b),
      )],
    );
    _workoutService.updateWorkout(state).then((_) {
      // Refresh the workout list after updating
      ref.read(workoutItemProvider.notifier).getWorkouts();
      Navigator.pop(context, state);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// Updated provider declaration
final workoutProvider = StateNotifierProvider.family<WorkoutNotifier, Workout, Workout>((ref, workout) => WorkoutNotifier(ref, workout));