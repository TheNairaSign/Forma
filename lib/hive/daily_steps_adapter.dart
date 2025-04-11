import 'package:hive/hive.dart';

part 'adapter/daily_steps_adapter.g.dart';

@HiveType(typeId: 1)
class DailySteps {
  @HiveField(0)
  final DateTime date; // YYYY-MM-DD format
  
  @HiveField(1)
  final int steps;
  
  @HiveField(2)
  final DateTime lastUpdated;

  DailySteps({
    required this.date,
    required this.steps,
    required this.lastUpdated,
  });

  DailySteps copyWith({
    DateTime? date,
    int? steps,
    DateTime? lastUpdated,
  }) {
    return DailySteps(
      date: date ?? this.date,
      steps: steps ?? this.steps,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}