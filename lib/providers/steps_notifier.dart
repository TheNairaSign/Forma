// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workout_tracker/hive/daily_steps_adapter.dart';
import 'package:workout_tracker/models/steps_state.dart';
import 'package:workout_tracker/utils/alerts.dart';

class StepsNotifier extends StateNotifier<StepsState> {
  StepsNotifier() : super(StepsState(
    stepCountStream: const Stream.empty(),
    pedestrianStatusStream: const Stream.empty(),
    status: '0',
    steps: 0,
  ));

  final Box<DailySteps> _dailyStepsBox = Hive.box<DailySteps>('dailyStepsBox');
  DateTime _currentDate = DateTime.now();

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;


  final int _dailyTargetSteps = 10000;
  int get dailyTargetSteps => _dailyTargetSteps;

  double stepsProgress(int? animationValue) {
    if (animationValue != null || animationValue != 0) {
      return animationValue!  / _dailyTargetSteps;
    } else {
      return state.steps / _dailyTargetSteps;
    }
  }

  String _getDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> onStepCount(int stepCount) async {
    final currentDate = DateTime.now();
    if (currentDate != _currentDate) {
      _currentDate = currentDate;
    }
    
    final dateKey = _getDateKey(_currentDate);
    final dailySteps = _dailyStepsBox.get(dateKey);


    if (dailySteps != null) {
      debugPrint('Daily Steps: ${dailySteps.steps}');
      await _dailyStepsBox.put(dateKey, DailySteps(
        date: _currentDate,
        steps: dailySteps.steps + stepCount,
        lastUpdated: DateTime.now(),
      ));  
    } else {
      debugPrint('Steps Count: $stepCount');
      await _dailyStepsBox.put(dateKey, DailySteps(
        date: _currentDate,
        steps: stepCount,
        lastUpdated: DateTime.now(),
      ));
    }
    state = state.copyWith(steps: stepCount);
  }

  // Update getTodaySteps to use the new key format
  int getTodaySteps() {
    final today = _getDateKey(DateTime.now());
    return _dailyStepsBox.get(today)?.steps ?? 0;
  }

  // Update getStepsForDate to use the new key format
  int? getStepsForDate(DateTime date) {
    return _dailyStepsBox.get(_getDateKey(date))?.steps;
  }

  // Get all stored step data
  List<DailySteps> getAllSteps() {
    return _dailyStepsBox.values.toList();
  }

  /// Handle status changed
  void onPedestrianStatusChanged(PedestrianStatus event) {
    state =  state.copyWith(status: event.status);
  }

    /// Handle the error
  void onPedestrianStatusError(error) {
    debugPrint('onPedestrianStatusError: $error');
    state = state.copyWith(status: 'Pedestrian Status not available');
    debugPrint('Error Status: ${state.status}');
  }

  /// Handle the error
  void onStepCountError(error) {
    debugPrint('onStepCountError: $error');
    state = state.copyWith(steps: 0);
  }

  Future<bool> _checkActivityRecognitionPermission() async {
    bool granted = await Permission.activityRecognition.isGranted;

    if (!granted) {
      granted = await Permission.activityRecognition.request() == PermissionStatus.granted;
    }

    return granted;
  }

  Future<void> initPlatformState(BuildContext context) async {
    bool granted = await _checkActivityRecognitionPermission();
    if (!granted) {
      debugPrint('Permission not granted');
      Alerts.showErrorDialog(context, 'Permission not granted', 'Enable activity permission to track steps');
      // show a dialog to the user to enable the permission in the settings men
      return;
    }

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    (_pedestrianStatusStream.listen(onPedestrianStatusChanged)).onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen((StepCount event) => onStepCount(event.steps)).onError(onStepCountError);

    // final today = _getDateKey(DateTime.now());

    state = state.copyWith(
      stepCountStream: _stepCountStream,
      pedestrianStatusStream: _pedestrianStatusStream,
      // steps: _dailyStepsBox.get(today)?.steps.toString() ?? '0'
    );

    if (!mounted) return;
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}

final stepsProvider = StateNotifierProvider<StepsNotifier, StepsState>((ref) => StepsNotifier());
