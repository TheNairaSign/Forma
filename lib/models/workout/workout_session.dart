class WorkoutSession {
  final DateTime timestamp;
  final int? durationInSeconds;
  final int? setsCompleted;
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