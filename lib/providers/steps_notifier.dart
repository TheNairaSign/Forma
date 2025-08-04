
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workout_tracker/hive/daily_steps_adapter.dart';
import 'package:workout_tracker/hive/hourly_steps.dart';
import 'package:workout_tracker/hive/step_entry.dart';
import 'package:workout_tracker/models/state/steps_state.dart';
import 'package:workout_tracker/providers/box_providers.dart';
import 'package:workout_tracker/providers/calories_provider.dart';
import 'package:workout_tracker/services/steps_service.dart';
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
  Box<HourlySteps> get _hourlyStepsBox => ref.watch(hourlyStepsBoxProvider);

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

  final _targetStepsController = TextEditingController(text: '10000');
  TextEditingController get targetStepsController => _targetStepsController;

  void updateTargetSteps(BuildContext context) {
    if (_targetStepsController.text.isEmpty || _targetStepsController.text == '') return;
    _dailyTargetSteps = int.parse(_targetStepsController.text);
    debugPrint('Updated target steps to $_dailyTargetSteps');
    FlushbarService.show(context, message: 'Target steps updated to $_dailyTargetSteps');
    state = state;
  }

  int get stepsCalory {
    final calories = (state.steps * 0.04).truncate();
    debugPrint('Steps Calory: $calories');
    return calories;
  }

  void addStepCalories() {
    final calorieProvider = ref.read(caloriesProvider.notifier);
    calorieProvider.addCalories(stepsCalory);
  }


  double stepsProgress(int? animationValue) {
    final value = (animationValue ?? state.steps).toDouble();
    return (value / _dailyTargetSteps).clamp(0.0, 1.0);
  }

  String _getDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  int? _lastUpdatedHour;
  DateTime? _lastUpdateDate;
  
  void onStepCount(int stepCount) {
    final currentDate = DateTime.now();

    // Store the raw step deltas (keep this for data tracking)
    final deltaBox = Hive.box<StepEntry>('step_deltas');
    deltaBox.add(StepEntry(timestamp: currentDate, steps: stepCount));
    
    if (currentDate != _currentDate) {
      _currentDate = currentDate;
    }
    
    final dateKey = _getDateKey(_currentDate);
    
    try {
      // Update daily steps only
      final box = _dailyStepsBox;
      box.put(dateKey, DailySteps(
        date: _currentDate,
        steps: stepCount,
        lastUpdated: DateTime.now(),
      ));
      
      // Calculate hourly data on-demand (no persistence)
      final hourlySteps = calculateHourlyStepsForToday();
      
      // Update state
      state = state.copyWith(
        steps: stepCount,
        hourlySteps: hourlySteps,
      );
    } catch (e) {
      debugPrint('Error updating step count: $e');
    }
  }

  List<HourlySteps> calculateHourlyStepsForToday() {
    final stepsService = StepsService();
    final hourlyStepsForDay = stepsService.calculateHourlyStepsForToday();
    for (var hourlyStep in hourlyStepsForDay) {
      debugPrint('Hourly Steps for Today: ${hourlyStep.hour} : With Steps: ${hourlyStep.steps}');

    }
    return hourlyStepsForDay;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
  
  void _updateHourlySteps(int stepCount, DateTime timestamp) {
    try {
      final stepsService = StepsService();
      stepsService.updateHourlySteps(_hourlyStepsBox, stepCount, timestamp);
      debugPrint('Updated hourly steps for hour ${timestamp.hour}: $stepCount');
    } catch (e) {
      debugPrint('Error updating hourly steps: $e');
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
  
  // Get steps for the current hour
  int getCurrentHourSteps() {
    try {
      final now = DateTime.now();
      final stepsService = StepsService();
      return stepsService.getStepsForHour(_hourlyStepsBox, now, now.hour);
    } catch (e) {
      debugPrint('Error getting current hour steps: $e');
      return 0;
    }
  }
  
  // Get steps for a specific hour on a specific date
  int getStepsForHourOnDate(DateTime date, int hour) {
    try {
      final stepsService = StepsService();
      return stepsService.getStepsForHour(_hourlyStepsBox, date, hour);
    } catch (e) {
      debugPrint('Error getting steps for hour $hour on date ${DateFormat('yyyy-MM-dd').format(date)}: $e');
      return 0;
    }
  }
  
  // Get hourly steps for today
  Map<int, int> getHourlyStepsForToday() {
    try {
      final stepsService = StepsService();
      return stepsService.getHourlySteps(_hourlyStepsBox);
    } catch (e) {
      debugPrint('Error getting hourly steps for today: $e');
      return {for (var h = 0; h < 24; h++) h: 0};
    }
  }
  
  // Get hourly steps for a specific date
  Map<int, int> getHourlyStepsForDate(DateTime date) {
    try {
      final stepsService = StepsService();
      return stepsService.getHourlyStepsForDate(_hourlyStepsBox, date);
    } catch (e) {
      debugPrint('Error getting hourly steps for date ${DateFormat('yyyy-MM-dd').format(date)}: $e');
      return {for (var h = 0; h < 24; h++) h: 0};
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


  DailySteps? _bestPerformingDayData;
  DailySteps? _worstPerformingDayData;

  DailySteps? get bestPerformingDayData => _bestPerformingDayData;
  DailySteps? get worstPerformingDayData => _worstPerformingDayData;

  List<DailySteps> getWeeklySteps() {
    final weeklySteps = <DailySteps>[];
    final now = DateTime.now();

    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    // Reset/Initialize before processing the week
    _bestPerformingDayData = null;
    _worstPerformingDayData = null;

    _highestWeeklyStep = 0;
    _lowestWeeklyStep = dailyTargetSteps; // Initialize lowest to target or a very high number

    final box = _dailyStepsBox;

    for (int i = 0; i < 7; i++) {
      final date = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + i);
      final dateKey = _getDateKey(date);
      DailySteps? dailyData = box.get(dateKey);

      dailyData ??= DailySteps(
        date: date,
        steps: 0,
        lastUpdated: date, // Or use a default like DateTime.now()
      );

      weeklySteps.add(dailyData);

      // --- Logic for Best Performing Day ---
      if (_bestPerformingDayData == null || dailyData.steps > _bestPerformingDayData!.steps) {
        _bestPerformingDayData = dailyData;
      }
      // If you keep _highestWeeklyStep:
      if (dailyData.steps > _highestWeeklyStep) {
        _highestWeeklyStep = dailyData.steps;
      }

      // --- Logic for Worst Performing Day (includes 0 steps) ---
      if (_worstPerformingDayData == null || dailyData.steps < _worstPerformingDayData!.steps) {
        _worstPerformingDayData = dailyData;
      }
      // If you keep _lowestWeeklyStep:
      if (dailyData.steps < _lowestWeeklyStep) {
        _lowestWeeklyStep = dailyData.steps;
      }
    }

    // The list is already built in day order (Mon-Sun), so sorting might be redundant
    // if startOfWeek logic and loop are correct. But explicit sort doesn't hurt.
    weeklySteps.sort((a, b) => a.date.compareTo(b.date));

    // Debug print to verify
    debugPrint('Best Day: ${_bestPerformingDayData?.date} - ${_bestPerformingDayData?.steps} steps');
    debugPrint('Worst Day: ${_worstPerformingDayData?.date} - ${_worstPerformingDayData?.steps} steps');

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

    // Get hourly steps for today
    // final hourlySteps = calculateHourlyStepsForToday();

    state = state.copyWith(
      stepCountStream: _stepCountStream,
      pedestrianStatusStream: _pedestrianStatusStream,
      // hourlySteps: hourlySteps,
    );

    debugPrint('🚀 Steps Notifier initialized - Status: ${state.status}, Daily steps: ${state.steps}, Date: ${state.date}');
  }


  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}

final stepsProvider = StateNotifierProvider<StepsNotifier, StepsState>((ref) => StepsNotifier(ref));
