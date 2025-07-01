
// ignore_for_file: non_constant_identifier_names

enum WorkoutType {
  fullBody,
  chest,
  back,
  shoulders,
  legs,
  arms,
  core,
  cardio,
  hiit,
  pushDay,
  pullDay,
  upperBody,
  lowerBody,
  yoga,
  mobility,
  strength,
  endurance,
  balance,
  flexibility,
  warmUp,
  coolDown,
}

extension WorkoutTypeExtension on WorkoutType {
  // MET (Metabolic Equivalent of Task) values
  //! MET values are based on average values for different types of workouts
  //! Higher MET values indicate more intense and calorie-burning workouts
  //! Lower MET values indicate less intense workouts
  double get MET {
    switch (this) {
      case WorkoutType.fullBody:
        return 8.0;
      case WorkoutType.chest:
      case WorkoutType.back:
      case WorkoutType.shoulders:
        return 6.0;
      case WorkoutType.legs:
        return 7.0;
      case WorkoutType.arms:
        return 5.5;
      case WorkoutType.core:
        return 5.0;
      case WorkoutType.cardio:
        return 7.0;
      case WorkoutType.hiit:
        return 10.0;
      case WorkoutType.pushDay:
      case WorkoutType.pullDay:
      case WorkoutType.upperBody:
        return 6.5;
      case WorkoutType.lowerBody:
        return 7.0;
      case WorkoutType.yoga:
        return 2.5;
      case WorkoutType.mobility:
        return 3.0;
      case WorkoutType.strength:
        return 6.5;
      case WorkoutType.endurance:
        return 7.5;
      case WorkoutType.balance:
      case WorkoutType.flexibility:
        return 2.5;
      case WorkoutType.warmUp:
        return 3.0;
      case WorkoutType.coolDown:
        return 2.0;
    }
  }

  // Default durations (in minutes)
  int get defaultDuration {
    switch (this) {
      case WorkoutType.hiit:
        return 20;
      case WorkoutType.yoga:
        return 45;
      case WorkoutType.warmUp:
      case WorkoutType.coolDown:
        return 10;
      default:
        return 30;
    }
  }

  // Estimate calories based on user weight (kg) and optional custom duration
  double estimateCaloriesBurned({required double weightKg, int? durationMinutes}) {
    final duration = (durationMinutes ?? defaultDuration) / 60; // to hours
    return MET * weightKg * duration;
  }

  // Optional: add emoji for UI
  String get emoji {
    switch (this) {
      case WorkoutType.fullBody:
        return "🏋️";
      case WorkoutType.cardio:
        return "🏃";
      case WorkoutType.hiit:
        return "🔥";
      case WorkoutType.yoga:
        return "🧘";
      case WorkoutType.legs:
        return "🦵";
      case WorkoutType.arms:
        return "💪";
      case WorkoutType.core:
        return "📦";
      case WorkoutType.coolDown:
        return "❄️";
      case WorkoutType.warmUp:
        return "🔥";
      case WorkoutType.strength:
        return "🏋️‍♂️";
      default:
        return "🏃‍♂️";
    }
  }

  String get name {
    switch (this) {
      case WorkoutType.fullBody:
        return "Full Body";
      case WorkoutType.chest:
        return "Chest";
      case WorkoutType.back:
        return "Back";
      case WorkoutType.shoulders:
        return "Shoulders";
      case WorkoutType.legs:
        return "Legs";
      case WorkoutType.arms:
        return "Arms";
      case WorkoutType.core:
        return "Core";
      case WorkoutType.cardio:
        return "Cardio";
      case WorkoutType.hiit:
        return "HIIT (High-Intensity Interval Training)";
      case WorkoutType.pushDay:
        return "Push Day";
      case WorkoutType.pullDay:
        return "Pull Day";
      case WorkoutType.upperBody:
        return "Upper Body";
      case WorkoutType.lowerBody:
        return "Lower Body";
      case WorkoutType.yoga:
        return "Yoga";
      case WorkoutType.mobility:
        return "Mobility";
      case WorkoutType.strength:
        return "Strength";
      case WorkoutType.endurance:
        return "Endurance";
      case WorkoutType.balance:
        return "Balance";
      case WorkoutType.flexibility:
        return "Flexibility";
      case WorkoutType.warmUp:
        return "Warm Up";
      case WorkoutType.coolDown:
        return "Cool Down";
    }
  }
}

void getWorkoutType() {
  final workoutType = WorkoutType.fullBody;
  print("${workoutType.name} (${workoutType.MET} MET)");
}