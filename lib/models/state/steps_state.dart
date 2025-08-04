import 'package:pedometer/pedometer.dart';
import 'package:workout_tracker/hive/hourly_steps.dart';

class StepsState {
  Stream<StepCount> stepCountStream;
  Stream<PedestrianStatus> pedestrianStatusStream;
  int steps;
  String status;
  final DateTime date;
  final List<HourlySteps> hourlySteps;

  StepsState({
    required this.stepCountStream,
    required this.pedestrianStatusStream,
    required this.status,
    required this.steps,
    required this.date,
    List<HourlySteps>? hourlySteps,
  }) : this.hourlySteps = hourlySteps ?? _generateEmptyHourlySteps(date);

  StepsState copyWith({
    Stream<StepCount>? stepCountStream,
    Stream<PedestrianStatus>? pedestrianStatusStream,
    String? status,
    int? steps,
    DateTime? date,
    List<HourlySteps>? hourlySteps,
  }) {
    return StepsState(
      stepCountStream: stepCountStream ?? this.stepCountStream,
      pedestrianStatusStream: pedestrianStatusStream ?? this.pedestrianStatusStream,
      status: status ?? this.status,
      steps: steps ?? this.steps,
      date: date ?? this.date,
      hourlySteps: hourlySteps ?? this.hourlySteps,
    );
  }

  /// Generate empty hourly steps for all 24 hours
  static List<HourlySteps> _generateEmptyHourlySteps(DateTime date) {
    final dayStart = DateTime(date.year, date.month, date.day);
    
    return List.generate(24, (hour) {
      return HourlySteps(
        timestamp: dayStart,
        hour: hour,
        steps: 0,
        lastUpdated: dayStart,
      );
    });
  }

  int stepsForHour(int hour) {
    if (hour < 0 || hour > 23) return 0;
    
    try {
      return hourlySteps.firstWhere((h) => h.hour == hour).steps;
    } catch (e) {
      return 0;
    }
  }

   /// Operator overload to access hourly steps like a map
  int operator [](int hour) => stepsForHour(hour);

  /// Convert to Map format (for backward compatibility with existing UI code)
  Map<int, int> get hourlyStepsMap {
    return {
      for (final hourly in hourlySteps)
        hourly.hour: hourly.steps
    };
  }
}
