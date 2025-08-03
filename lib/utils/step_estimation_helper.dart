class StepEstimationHelper {
  /// Estimates the number of steps based on the distance in meters.
  /// The average step length is assumed to be 0.762 meters (2.5 feet).
  static int estimateStepsFromDistance(double distanceInMeters) {
    const double averageStepLength = 0.762; // Average step length in meters
    if (distanceInMeters < 0) {
      throw ArgumentError('Distance cannot be negative');
    }
    return (distanceInMeters / averageStepLength).round();
  }

  static double estimateDistanceKm(int steps, {double strideLengthMeters = 0.762}) {
    return (steps * strideLengthMeters) / 1000; // convert to kilometers
  }

  // Estimate time in minutes (average walking pace is 100 steps/min)
  static int estimateTimeMinutes(int steps, {int stepsPerMinute = 100}) {
    return (steps / stepsPerMinute).floor();
  }

  // Estimate calories burned (basic estimate)
  static double estimateCaloriesBurned(int steps, {double caloriesPerStep = 0.04}) {
    return steps * caloriesPerStep;
  }

  String formatDurationFromSteps(int steps, {int stepsPerMinute = 100}) {
    int minutes = (steps / stepsPerMinute).floor();
    if (minutes < 1) {
      int seconds = ((steps / stepsPerMinute) * 60).round();
      return "$seconds s";
    } else if (minutes < 60) {
      return "$minutes mins";
    } else {
      int hours = (minutes / 60).floor();
      return "$hours hrs ${minutes % 60} mins";
    }
  }

  String formatDistance(int steps, {double strideLengthMeters = 0.762}) {
    // Estimate distance in meters (1 step ≈ 0.78 meters)
    double meters = steps * strideLengthMeters;

    if (meters < 1000) {
      return "${meters.toStringAsFixed(0)} m";
    } else if (meters < 1609.34) {
      return "${(meters / 1000).toStringAsFixed(2)} km";
    } else {
      return "${(meters / 1609.34).toStringAsFixed(2)} mi";
    }
  }

  String calculateCalories(int steps) {
    double calories = steps * 0.04;
    return "${calories.toStringAsFixed(0)} KCAL";
  }
}