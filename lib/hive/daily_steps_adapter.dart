import 'package:hive/hive.dart';

part 'adapter/daily_steps_adapter.g.dart';

@HiveType(typeId: 1)
class DailySteps {
  @HiveField(0)
  final DateTime date;
  
  @HiveField(1)
  final int steps;
  
  @HiveField(2)
  final DateTime lastUpdated;

  @HiveField(3)
  final int? lastPedometerValue;


  DailySteps({
    required this.date,
    required this.steps,
    required this.lastUpdated,
    this.lastPedometerValue,
  });

  DailySteps copyWith({
    DateTime? date,
    int? steps,
    DateTime? lastUpdated,
    int? lastPedometerValue,
  }) {
    return DailySteps(
      date: date ?? this.date,
      steps: steps ?? this.steps,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      lastPedometerValue: lastPedometerValue ?? this.lastPedometerValue,
    );
  }
}