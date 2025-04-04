import 'package:uuid/uuid.dart';
import 'package:workout_tracker/models/workout/workout_session.dart';

class Workout {
  String id;
  String name;
  int sets;
  int reps;
  int durationInSeconds;
  bool isActive;
  String? description;
  List<WorkoutSession> sessions;
  int? goalReps;
  int? goalDuration;

  Workout({
    required this.name,
    required this.sets,
    required this.reps,
    this.durationInSeconds = 0,
    this.isActive = false,
    this.description,
    this.sessions = const [],
    this.goalReps,
    this.goalDuration,
  }) : id = Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name': name,
      'sets': sets,
      'reps': reps,
      'durationInSeconds': durationInSeconds,
      'isActive': isActive,
      'description': description,
      'sessions': sessions.map((s) => s.toMap()).toList(),
      'goalReps': goalReps,
      'goalDuration': goalDuration,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      name: map['name'],
      sets: map['sets'],
      reps: map['reps'],
      durationInSeconds: map['durationInSeconds'] ?? 0,
      isActive: map['isActive'] ?? false,
      description: map['description'],
      sessions: (map['sessions'] as List? ?? []).map((s) => WorkoutSession.fromMap(s)).toList(),
      goalReps: map['goalReps'],
      goalDuration: map['goalDuration'],
    )..id = map['id'];
  }

  Workout copyWith({
    String? name,
    int? sets,
    int? reps,
    int? durationInSeconds,
    bool? isActive,
    String? description,
    List<WorkoutSession>? sessions,
    int? goalReps,
    int? goalDuration,
  }) {
    return Workout(
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
      sessions: sessions ?? this.sessions,
      goalReps: goalReps ?? this.goalReps,
      goalDuration: goalDuration ?? this.goalDuration,
    );
  }
}


