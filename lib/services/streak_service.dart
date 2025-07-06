
import 'package:workout_tracker/models/workout/workout.dart';
import 'package:workout_tracker/services/workout_service.dart';

class StreakService {
  final WorkoutService _workoutService = WorkoutService();

  Future<int> calculateStreak() async {
    final historyMaps = await _workoutService.getHistory();
    if (historyMaps.isEmpty) {
      return 0;
    }

    final workoutDates = historyMaps
        .map((map) => Workout.fromMap(map as Map<String, dynamic>))
        .expand((workout) => workout.sessions.map((session) => session.timestamp.toLocal()))
        .map((dateTime) => DateTime(dateTime.year, dateTime.month, dateTime.day))
        .toSet();

    if (workoutDates.isEmpty) {
      return 0;
    }

    final sortedDates = workoutDates.toList()..sort((a, b) => b.compareTo(a));

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    DateTime? lastWorkoutDate;
    if (sortedDates.first.isAtSameMomentAs(todayDate)) {
      lastWorkoutDate = todayDate;
    } else if (sortedDates.first.isAtSameMomentAs(todayDate.subtract(const Duration(days: 1)))) {
      lastWorkoutDate = todayDate.subtract(const Duration(days: 1));
    } else {
      return 0;
    }

    int streak = 0;
    if (lastWorkoutDate != null) {
      streak = 1;
      DateTime currentDate = lastWorkoutDate;
      while (workoutDates.contains(currentDate.subtract(const Duration(days: 1)))) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      }
    }

    return streak;
  }
}
