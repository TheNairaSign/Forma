import 'package:hive/hive.dart';

part 'adapter/hourly_steps_adapter.g.dart';

@HiveType(typeId: 9)
class HourlySteps {
  @HiveField(0)
  final DateTime timestamp;
  
  @HiveField(1)
  final int hour;
  
  @HiveField(2)
  final int steps;
  
  @HiveField(3)
  final DateTime lastUpdated;

  HourlySteps({
    required this.timestamp,
    required this.hour,
    required this.steps,
    required this.lastUpdated,
  });

  HourlySteps copyWith({
    DateTime? timestamp,
    int? hour,
    int? steps,
    DateTime? lastUpdated,
  }) {
    return HourlySteps(
      timestamp: timestamp ?? this.timestamp,
      hour: hour ?? this.hour,
      steps: steps ?? this.steps,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}