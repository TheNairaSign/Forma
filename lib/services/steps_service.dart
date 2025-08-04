// lib/services/steps_service.dart
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker/hive/daily_steps_adapter.dart';
import 'package:workout_tracker/hive/hourly_steps.dart';
import 'package:workout_tracker/hive/step_entry.dart';

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

  List<HourlySteps> calculateHourlyStepsForToday() {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    // Get all step entries for today
    final deltaBox = Hive.box<StepEntry>('step_deltas');
    final todayEntries = deltaBox.values
        .where((entry) => 
            entry.timestamp.isAfter(todayStart) && 
            entry.timestamp.isBefore(todayEnd))
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if (todayEntries.isEmpty) {
      return [];
    }

    // Group entries by hour and calculate hourly steps
    final Map<int, List<StepEntry>> hourlyGroups = {};
    
    for (final entry in todayEntries) {
      final hour = entry.timestamp.hour;
      hourlyGroups[hour] ??= [];
      hourlyGroups[hour]!.add(entry);
    }

    final List<HourlySteps> hourlySteps = [];
    
    // Calculate steps for each hour
    for (int hour = 0; hour <= 23; hour++) {
      final entriesForHour = hourlyGroups[hour];
      
      if (entriesForHour == null || entriesForHour.isEmpty) {
        // No activity this hour - but only add if we're past this hour or it's current hour
        if (hour <= today.hour) {
          hourlySteps.add(HourlySteps(
            timestamp: todayStart,
            hour: hour,
            steps: 0,
            lastUpdated: today,
          ));
        }
        continue;
      }

      // Get the step count difference for this hour
      final firstEntry = entriesForHour.first;
      final lastEntry = entriesForHour.last;
      
      // Calculate steps taken during this hour
      int hourlyStepCount;
      
      if (hour == 0) {
        // First hour of the day - use the last entry's value
        hourlyStepCount = lastEntry.steps;
      } else {
        // Find the last entry from the previous hour
        int previousHourTotal = 0;
        
        for (int prevHour = hour - 1; prevHour >= 0; prevHour--) {
          final prevHourEntries = hourlyGroups[prevHour];
          if (prevHourEntries != null && prevHourEntries.isNotEmpty) {
            previousHourTotal = prevHourEntries.last.steps;
            break;
          }
        }
        
        hourlyStepCount = lastEntry.steps - previousHourTotal;
      }

      // Ensure no negative steps
      hourlyStepCount = hourlyStepCount < 0 ? 0 : hourlyStepCount;

      hourlySteps.add(HourlySteps(
        timestamp: todayStart,
        hour: hour,
        steps: hourlyStepCount,
        lastUpdated: lastEntry.timestamp,
      ));
    }

    return hourlySteps;
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

    // Get all entries for the current day up to the previous hour
    final previousHoursEntries = box.values.where((entry) =>
      entry.timestamp.year == today.year &&
      entry.timestamp.month == today.month &&
      entry.timestamp.day == today.day &&
      entry.hour < hour
    ).toList();

    // Sum the steps from all previous hours
    int previousTotalSteps = previousHoursEntries.fold(0, (sum, entry) => sum + entry.steps);

    // Calculate the steps for the current hour
    int hourlySteps = totalStepCount - previousTotalSteps;

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