
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workout_tracker/hive/daily_steps_adapter.dart';
import 'package:workout_tracker/hive/step_entry.dart';
import 'package:workout_tracker/models/state/steps_state.dart';
import 'package:workout_tracker/providers/box_providers.dart';
import 'package:workout_tracker/utils/alerts.dart';
import 'package:workout_tracker/utils/flush/flushbar_service.dart';

class StepsNotifier extends StateNotifier<StepsState> {
  final Ref ref;
  StepsNotifier(this.ref) : super(StepsState(
    stepCountStream: const Stream.empty(),
    pedestrianStatusStream: const Stream.empty(),
    status: '0',
    steps: 0,
    date: DateTime.now(),
  ));

  Box<DailySteps> get _dailyStepsBox => ref.watch(stepsBoxProvider);

  DateTime getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  DateTime _currentDate = DateTime.now();

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  String _selectedRange = 'Daily';
  String get selectedRange => _selectedRange;

  int _highestWeeklyStep = 0;
  int get highestWeeklyStep => _highestWeeklyStep;

  int _lowestWeeklyStep = 0;
  int get lowestWeeklyStep => _lowestWeeklyStep;

  // int _highestMonthlyStep = 0;

  void setSelectedRange(String range) {
    debugPrint('Selected Range: $range');
    _selectedRange = range;
  }


  int _dailyTargetSteps = 10000;
  int get dailyTargetSteps => _dailyTargetSteps;

  bool _isEdit = false;
  bool get isEdit => _isEdit;

  void updateIsEdit(String value) async {

    if (value != _dailyTargetSteps.toString()) {
      debugPrint('Value changed: $value, current target: $_dailyTargetSteps');
      _isEdit = true;
      // _targetCalorieController.text = value;
      state = state;

    } else {
      _isEdit = false;
      debugPrint('Value is the same as target calories, setting isEdit to false');
      state = state;
    }
    print('Update isEdit to: $_isEdit');
  }

  final _targetStepsController = TextEditingController(text: '10000');
  TextEditingController get targetStepsController => _targetStepsController;

  void updateTargetSteps(BuildContext context) {
    if (_targetStepsController.text.isEmpty || _targetStepsController.text == '') return;
    _dailyTargetSteps = int.parse(_targetStepsController.text);
    debugPrint('Updated target steps to $_dailyTargetSteps');
    FlushbarService.show(context, message: 'Target steps updated to $_dailyTargetSteps');
    state = state;
  }

  int stepsCalory = 0;

  // int get stepsCalory {
  //   final calories = (state.steps * 0.04).truncate();
  //   debugPrint('Steps Calory: $calories');
  //   return calories;
  // }

  double stepsProgress(int? animationValue) {
    final value = (animationValue ?? state.steps).toDouble();
    return (value / _dailyTargetSteps).clamp(0.0, 1.0);
  }

  String _getDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void onStepCount(int stepCount) {
    final currentDate = DateTime.now();

    final deltaBox = Hive.box<StepEntry>('step_deltas');

    deltaBox.add(StepEntry(timestamp: currentDate, steps: stepCount));
    if (currentDate != _currentDate) {
      _currentDate = currentDate;
    }
    
    final dateKey = _getDateKey(_currentDate);
    try {
      final box = _dailyStepsBox;
      final dailySteps = box.get(dateKey);

      if (dailySteps != null) {
        debugPrint('Step Count: ${dailySteps.steps}');
        box.put(dateKey, DailySteps(
          date: _currentDate,
          // steps: dailySteps.steps + stepCount,
          steps: stepCount,
          lastUpdated: DateTime.now(),
        ));  
      } else {
        debugPrint('Steps Count: $stepCount');
        box.put(dateKey, DailySteps(
          date: _currentDate,
          steps: stepCount,
          lastUpdated: DateTime.now(),
        ));
      }
      state = state.copyWith(steps: stepCount);
    } catch (e) {
      debugPrint('Error updating step count: $e');
    }
  }

  // Update getTodaySteps to use the new key format
  int getTodaySteps() {
    try {
      final today = _getDateKey(DateTime.now());
      final box = _dailyStepsBox;
      return box.get(today)?.steps ?? 0;
    } catch (e) {
      debugPrint('Error getting today steps: $e');
      return 0;
    }
  }


  List<DailySteps> getDailySteps() {
    try {
      final today = _getDateKey(DateTime.now());
      final box = _dailyStepsBox;
      final dailySteps = box.get(today);

      if (dailySteps != null) {
        debugPrint('Daily Steps: ${dailySteps.steps}');
        return [dailySteps];
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Error getting daily steps: $e');
      return [];
    }
  }

  /*
  Map<int, int> getHourlySteps() {
    // Initialize map with 24 hours (0-23) set to 0 steps
    final Map<int, int> hourlyBreakdown = { 
      for (var hour in List.generate(24, (index) => index)) hour : 0 
    };
    
    try {
      final today = DateTime.now();
      final dateKey = _getDateKey(today);
      final box = _dailyStepsBox;
      final dailySteps = box.get(dateKey);
      
      if (dailySteps != null) {
        final lastUpdate = dailySteps.lastUpdated;
        final currentHour = lastUpdate.hour;
        
        // Distribute steps across hours up to the last update
        // Simple distribution - divides steps evenly across active hours
        final activeHours = currentHour + 1;
        final stepsPerHour = (dailySteps.steps / activeHours).floor();
        
        for (int i = 0; i <= currentHour; i++) {
          hourlyBreakdown[i] = stepsPerHour;
        }
        
        // Add remaining steps to the current hour
        final remainingSteps = dailySteps.steps - (stepsPerHour * activeHours);
        hourlyBreakdown[currentHour] = (hourlyBreakdown[currentHour] ?? 0) + remainingSteps;
      }
    } catch (e) {
      debugPrint('Error getting hourly steps: $e');
    }

    return hourlyBreakdown;
  }
   */

  Map<int, int> getHourlySteps() {
    final box = Hive.box<StepEntry>('step_deltas');
    final entries = box.values.where((entry) {
      final now = DateTime.now();
      return entry.timestamp.year == now.year &&
          entry.timestamp.month == now.month &&
          entry.timestamp.day == now.day;
    });

    final Map<int, int> hourlySteps = Map.fromIterables(
      List.generate(24, (i) => i),
      List.generate(24, (_) => 0),
    );

    for (var entry in entries) {
      var hourly = hourlySteps[entry.timestamp.hour] ?? 0;
      hourly += entry.steps;
    }

    return hourlySteps;
  }


  List<DailySteps> getWeeklySteps() {
    final weeklySteps = <DailySteps>[];
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));

    _highestWeeklyStep = 0;  // Reset before checking
    _lowestWeeklyStep = _dailyTargetSteps;  // Start with target steps as max

    try {
      final box = _dailyStepsBox;
      
      for (int i = 0; i < 7; i++) {
        final date = startOfWeek.add(Duration(days: i));
        final dateKey = _getDateKey(date);
        final dailySteps = box.get(dateKey);

        if (dailySteps != null) {
          // Update highest and lowest steps
          if (dailySteps.steps > _highestWeeklyStep) {
            _highestWeeklyStep = dailySteps.steps;
          }
          if (dailySteps.steps < _lowestWeeklyStep) {
            _lowestWeeklyStep = dailySteps.steps;
          }
          
          weeklySteps.add(dailySteps);
          debugPrint('Weekly Steps for ${DateFormat('EEEE').format(date)}: ${dailySteps.steps}');
        } else {
          weeklySteps.add(DailySteps(
            date: date,
            steps: 0,
            lastUpdated: date,
          ));
          // Update lowest if we have a day with 0 steps
          _lowestWeeklyStep = 0;
        }
      }

      weeklySteps.sort((a, b) => a.date.compareTo(b.date));
    } catch (e) {
      debugPrint('Error getting weekly steps: $e');
    }
    
    return weeklySteps;
  }

  List<DailySteps> getMonthlySteps() {
    final monthlySteps = <DailySteps>[];
    final now = DateTime.now();

    // Get data for all 12 months starting from January
    for (int i = 0; i < 12; i++) {
      final date = DateTime(now.year, i + 1, 1);
      final monthTotal = _getMonthTotal(date);
      
      monthlySteps.add(DailySteps(
        date: date,
        steps: monthTotal,
        lastUpdated: now,
      ));
    }
    return monthlySteps;
  }

  int _getMonthTotal(DateTime date) {
    int total = 0;
    final daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    final box = _dailyStepsBox;
    
    for (int day = 1; day <= daysInMonth; day++) {
      final currentDate = DateTime(date.year, date.month, day);
      final dateKey = _getDateKey(currentDate);
      final dailySteps = box.get(dateKey);
      if (dailySteps != null) {
        total += dailySteps.steps;
      }
    }
    return total;
  }

  // Update getStepsForDate to use the new key format
  int? getStepsForDate(DateTime date) {
    final box = _dailyStepsBox;
    return box.get(_getDateKey(date))?.steps;
  }

  // Get all stored step data
  List<DailySteps> getAllSteps() {
    final box = _dailyStepsBox;
    return box.values.toList();
  }

  void clearAllSteps() {
    try {
      final box = _dailyStepsBox;
      box.clear();
      state = state.copyWith(steps: 0);
    } catch (e) {
      debugPrint('Error clearing all steps: $e');
    }
  }

  void resetSteps() {
    try {
      final today = DateTime.now();
      final dateKey = _getDateKey(today);
      final box = _dailyStepsBox;
      box.put(dateKey, DailySteps(
        date: today,
        steps: 0,
        lastUpdated: today,
      ));
      state = state.copyWith(steps: 0);
    } catch (e) {
      debugPrint('Error resetting steps: $e');
    }
  }

  /// Handle status changed
  void onPedestrianStatusChanged(PedestrianStatus event) => state =  state.copyWith(status: event.status);
  

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

final stepsProvider = StateNotifierProvider<StepsNotifier, StepsState>((ref) {
  // final userId = ref.watch(profileDataProvider).value;
  // if (userId == null) {
  //   debugPrint('User ID is null, cannot initialize StepsNotifier');
  //   return StepsNotifier(ref);
  // }
  // print('User id in steps provider: $userId');
  return StepsNotifier(ref);
});
