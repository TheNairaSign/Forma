import 'package:hive/hive.dart';

part 'workout_session.g.dart';

@HiveType(typeId: 5)
class WorkoutSession extends HiveObject {
  @HiveField(0)
  final DateTime timestamp;
  @HiveField(1)
  final int? durationInSeconds;
  @HiveField(2)
  final int? setsCompleted;
  @HiveField(3)
  final int? repsCompleted;

  WorkoutSession({
    required this.timestamp,
    this.durationInSeconds,
    this.setsCompleted,
    this.repsCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'durationInSeconds': durationInSeconds,
      'setsCompleted': setsCompleted,
      'repsCompleted': repsCompleted,
    };
  }

  factory WorkoutSession.fromMap(Map<String, dynamic> map) {
    return WorkoutSession(
      timestamp: DateTime.parse(map['timestamp']),
      durationInSeconds: map['durationInSeconds'],
      setsCompleted: map['setsCompleted'] ?? 0,
      repsCompleted: map['repsCompleted'] ?? 0,
    );
  }
}