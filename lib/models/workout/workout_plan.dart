
import 'package:workout_tracker/models/workout/workout.dart';

class WorkoutPlan {
  String name;
  List<Workout> workouts;
  List<WorkoutPlan> plans;

  WorkoutPlan({
    required this.name,
    this.workouts = const [],
    this.plans = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'workouts': workouts.map((w) => w.toMap()).toList(),
      'plans': plans.map((p) => p.toMap()).toList(),
    };
  }

  factory WorkoutPlan.fromMap(Map<String, dynamic> map) {
    return WorkoutPlan(
      name: map['name'],
      workouts: (map['workouts'] as List? ?? []).map((w) => Workout.fromMap(w)).toList(),
      // plans: (map['plans'] as List).map((p) => WorkoutPlan.fromMap(p)).toList(),
    );
  }

  WorkoutPlan copyWith({
    String? name,
    List<Workout>? workouts,
    List<WorkoutPlan>? plans,
  }) {
    return WorkoutPlan(
      name: name ?? this.name,
      workouts: workouts ?? this.workouts,
      plans: plans?? this.plans,
    );
  }
}