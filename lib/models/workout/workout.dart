import 'dart:ui';
import 'package:hive/hive.dart';

import 'package:uuid/uuid.dart';
import 'package:workout_tracker/models/enums/workout_group.dart';
import 'package:workout_tracker/models/workout/workout_session.dart';

part 'workout.g.dart';

@HiveType(typeId: 4)
class Workout extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  int? sets;
  @HiveField(3)
  int? reps;
  @HiveField(4)
  double? weight;
  @HiveField(5)
  int? distance;
  @HiveField(15)
  int? timeBasedSets;
  @HiveField(16)
  int? restTime;
  @HiveField(6)
  int durationInSeconds;
  @HiveField(7)
  bool isActive;
  @HiveField(8)
  String? description;
  @HiveField(9)
  List<WorkoutSession> sessions;
  @HiveField(10)
  int? goalReps;
  @HiveField(11)
  int? goalDuration;
  @HiveField(17)
  int? heartRate;
  @HiveField(12)
  WorkoutGroup? workoutGroup;
  @HiveField(13)
  String? intensity;
  @HiveField(14)
  Color? workoutColor;

  Workout({
    required this.name,
    this.sets,
    this.timeBasedSets,
    this.reps,
    this.weight,
    this.heartRate,
    this.restTime,
    this.distance,
    this.durationInSeconds = 0,
    this.isActive = false,
    this.description,
    this.sessions = const [],
    this.goalReps,
    this.goalDuration,
    this.intensity,
    this.workoutGroup,
    this.workoutColor,
  }) : id = Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name': name,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'distance': distance,
      'heartRate': heartRate,
      'restTime': restTime,
      'timeBasedSets': timeBasedSets,
      'durationInSeconds': durationInSeconds,
      'isActive': isActive,
      'description': description,
      'sessions': sessions.map((s) => s.toMap()).toList(),
      'goalReps': goalReps,
      'intensity': intensity,
      'goalDuration': goalDuration,
      'workoutGroup': workoutGroup,
      'workoutColor' : workoutColor
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      name: map['name'],
      sets: map['sets'],
      reps: map['reps'],
      weight: map['weight'],
      distance: map['distance'],
      restTime: map['restTime'],
      timeBasedSets: map['timeBasedSets'],
      durationInSeconds: map['durationInSeconds'] ?? 0,
      isActive: map['isActive'] ?? false,
      description: map['description'],
      sessions: (map['sessions'] as List? ?? []).map((s) => WorkoutSession.fromMap(s)).toList(),
      goalReps: map['goalReps'],
      heartRate: map['heartRate'],
      intensity: map['intensity'],
      goalDuration: map['goalDuration'],
      workoutGroup: map['workoutGroup'],
      workoutColor: map['workoutColor'],
    )..id = map['id'];
  }

  Workout copyWith({
    String? name,
    int? sets,
    int? reps,
    int? durationInSeconds,
    double? weight,
    int? distance,
    bool? isActive,
    int? timeBasedSets,
    int? restTime,
    String? description,
    List<WorkoutSession>? sessions,
    String? intensity,
    int? goalReps,
    int? goalDuration,
    int? heartRate,
    WorkoutGroup? workoutGroup,
    Color? workoutColor,
  }) {
    return Workout(
      name: name ?? this.name,
      weight: weight?? this.weight,
      distance: distance?? this.distance,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
      restTime: restTime?? this.restTime,
      timeBasedSets: timeBasedSets?? this.timeBasedSets,
      sessions: sessions ?? this.sessions,
      goalReps: goalReps ?? this.goalReps,
      heartRate: heartRate ?? this.heartRate,
      goalDuration: goalDuration ?? this.goalDuration,
      intensity: intensity?? this.intensity,
      workoutGroup: workoutGroup ?? this.workoutGroup,
      workoutColor: workoutColor ?? this.workoutColor,
    );
  }
}


