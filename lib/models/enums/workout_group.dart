import 'package:workout_tracker/models/enums/workout_type.dart';

enum WorkoutGroup {
  repetition,
  time,
  flow,
  strength,
  cardio,
}

final Map<WorkoutType, WorkoutGroup> workoutGroupMap = {
  WorkoutType.fullBody: WorkoutGroup.time,
  WorkoutType.chest: WorkoutGroup.repetition,
  WorkoutType.back: WorkoutGroup.repetition,
  WorkoutType.shoulders: WorkoutGroup.repetition,
  WorkoutType.legs: WorkoutGroup.repetition,
  WorkoutType.arms: WorkoutGroup.repetition,
  WorkoutType.core: WorkoutGroup.time,
  WorkoutType.cardio: WorkoutGroup.cardio,
  WorkoutType.hiit: WorkoutGroup.time,
  WorkoutType.pushDay: WorkoutGroup.repetition,
  WorkoutType.pullDay: WorkoutGroup.repetition,
  WorkoutType.upperBody: WorkoutGroup.repetition,
  WorkoutType.lowerBody: WorkoutGroup.repetition,
  WorkoutType.yoga: WorkoutGroup.flow,
  WorkoutType.mobility: WorkoutGroup.flow,
  WorkoutType.strength: WorkoutGroup.strength,
  WorkoutType.endurance: WorkoutGroup.time,
  WorkoutType.balance: WorkoutGroup.flow,
  WorkoutType.flexibility: WorkoutGroup.flow,
  WorkoutType.warmUp: WorkoutGroup.time,
  WorkoutType.coolDown: WorkoutGroup.time,
};
