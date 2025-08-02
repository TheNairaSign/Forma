import 'package:hive/hive.dart';

part 'step_entry.g.dart';

@HiveType(typeId: 8)
class StepEntry {
  @HiveField(0)
  final DateTime timestamp;

  @HiveField(1)
  final int steps;

  StepEntry({
    required this.timestamp,
    required this.steps,
  });
}
