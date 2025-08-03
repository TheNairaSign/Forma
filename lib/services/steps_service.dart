// lib/services/steps_service.dart
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker/hive/daily_steps_adapter.dart';
import 'package:workout_tracker/hive/hourly_steps.dart';

class StepsService {
  String _getDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  int getTodaySteps(Box<DailySteps> box) {
    final today = _getDateKey(DateTime.now());
    return box.get(today)?.steps ?? 0;
  }

  void updateSteps(Box<DailySteps> box, int stepCount, DateTime date) {
    final dateKey = _getDateKey(date);
    final dailySteps = box.get(dateKey);
    box.put(
      dateKey,
      DailySteps(
        date: date,
        steps: stepCount,
        lastUpdated: DateTime.now(),
      ),
    );
  }

  List<DailySteps> getDailySteps(Box<DailySteps> box) {
    final today = _getDateKey(DateTime.now());
    final dailySteps = box.get(today);
    return dailySteps != null ? [dailySteps] : [];
  }

  Map<int, int> getHourlySteps(Box<HourlySteps> box) {
    final now = DateTime.now();
    return getHourlyStepsForDate(box, now);
  }
  
  Map<int, int> getHourlyStepsForDate(Box<HourlySteps> box, DateTime date) {
    final targetDate = DateTime(date.year, date.month, date.day);
    
    final entries = box.values.where((entry) =>
      entry.timestamp.year == targetDate.year &&
      entry.timestamp.month == targetDate.month &&
      entry.timestamp.day == targetDate.day
    );
    
    final Map<int, int> hourlySteps = {for (var h = 0; h < 24; h++) h: 0};
    
    for (var entry in entries) {
      hourlySteps[entry.hour] = entry.steps;
      print('Hourly Steps for ${entry.timestamp}: Hour ${entry.hour} - ${entry.steps} steps');
    }
    
    return hourlySteps;
  }
  
  void updateHourlySteps(Box<HourlySteps> box, int totalStepCount, DateTime timestamp) {
    final hour = timestamp.hour;
    final today = DateTime(timestamp.year, timestamp.month, timestamp.day);
    final dateHourKey = '${_getDateKey(today)}_$hour';
    
    // Find the previous hour's step count (either from the same day or from the previous day)
    int previousHourSteps = 0;
    
    // If it's not the first hour of the day (hour 0), check the previous hour from the same day
    if (hour > 0) {
      final previousHour = hour - 1;
      final previousHourEntries = box.values.where((entry) =>
        entry.timestamp.year == today.year &&
        entry.timestamp.month == today.month &&
        entry.timestamp.day == today.day &&
        entry.hour == previousHour
      ).toList();
      
      if (previousHourEntries.isNotEmpty) {
        previousHourSteps = previousHourEntries.first.steps;
      }
    } else {
      // If it's the first hour of the day (hour 0), we start fresh with 0 as previous steps
      // This is because hour 0 (midnight) starts a new day's count
      previousHourSteps = 0;
    }
    
    // Calculate the steps for this hour by subtracting the previous hour's steps
    // If it's hour 0 (midnight), we use the total step count directly
    int hourlySteps = hour == 0 ? totalStepCount : totalStepCount - previousHourSteps;
    
    // Ensure we don't have negative steps (which could happen if the step counter was reset)
    hourlySteps = hourlySteps < 0 ? totalStepCount : hourlySteps;
    
    // Check if we already have an entry for this hour
    final existingEntries = box.values.where((entry) =>
      entry.timestamp.year == today.year &&
      entry.timestamp.month == today.month &&
      entry.timestamp.day == today.day &&
      entry.hour == hour
    ).toList();
    
    if (existingEntries.isNotEmpty) {
      // Update existing entry with the calculated hourly steps
      box.put(dateHourKey, HourlySteps(
        timestamp: today,
        hour: hour,
        steps: hourlySteps,
        lastUpdated: DateTime.now(),
      ));
    } else {
      // Create new entry with the calculated hourly steps
      box.put(dateHourKey, HourlySteps(
        timestamp: today,
        hour: hour,
        steps: hourlySteps,
        lastUpdated: DateTime.now(),
      ));
    }
    
    print('Updated hourly steps for hour $hour: Total steps = $totalStepCount, Hourly steps = $hourlySteps');
  }
  
  int getStepsForHour(Box<HourlySteps> box, DateTime date, int hour) {
    final dateHourKey = '${_getDateKey(date)}_$hour';
    final hourlySteps = box.get(dateHourKey);
    return hourlySteps?.steps ?? 0;
  }

  List<DailySteps> getWeeklySteps(Box<DailySteps> box, int dailyTargetSteps) {
    final weeklySteps = <DailySteps>[];
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    for (int i = 0; i < 7; i++) {
      final date = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + i);
      final dateKey = _getDateKey(date);
      final dailyData = box.get(dateKey) ??
        DailySteps(date: date, steps: 0, lastUpdated: date);
      weeklySteps.add(dailyData);
    }
    weeklySteps.sort((a, b) => a.date.compareTo(b.date));
    return weeklySteps;
  }

  List<DailySteps> getMonthlySteps(Box<DailySteps> box) {
    final monthlySteps = <DailySteps>[];
    final now = DateTime.now();
    for (int i = 0; i < 12; i++) {
      final date = DateTime(now.year, i + 1, 1);
      final monthTotal = _getMonthTotal(box, date);
      monthlySteps.add(DailySteps(
        date: date,
        steps: monthTotal,
        lastUpdated: now,
      ));
    }
    return monthlySteps;
  }

  int _getMonthTotal(Box<DailySteps> box, DateTime date) {
    int total = 0;
    final daysInMonth = DateTime(date.year, date.month + 1, 0).day;
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

  int? getStepsForDate(Box<DailySteps> box, DateTime date) {
    return box.get(_getDateKey(date))?.steps;
  }

  List<DailySteps> getAllSteps(Box<DailySteps> box) {
    return box.values.toList();
  }

  void clearAllSteps(Box<DailySteps> box) {
    box.clear();
  }

  void resetSteps(Box<DailySteps> box) {
    final today = DateTime.now();
    final dateKey = _getDateKey(today);
    box.put(dateKey, DailySteps(
      date: today,
      steps: 0,
      lastUpdated: today,
    ));
  }

}

class StepsServiceException implements Exception {
  final String message;
  StepsServiceException(this.message);

  @override
  String toString() {
    return 'StepsServiceException: $message';
  }
}