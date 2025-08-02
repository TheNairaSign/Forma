import 'package:pedometer/pedometer.dart';

class StepsState {
  Stream<StepCount> stepCountStream;
  Stream<PedestrianStatus> pedestrianStatusStream;
  int steps;
  String status;
  final DateTime date;
  final Map<int, int> hourlySteps;

  StepsState({
    required this.stepCountStream,
    required this.pedestrianStatusStream,
    required this.status,
    required this.steps,
    required this.date,
    Map<int, int>? hourlySteps,
  }) : this.hourlySteps = hourlySteps ?? {for (var h = 0; h < 24; h++) h: 0};

  StepsState copyWith({
    Stream<StepCount>? stepCountStream,
    Stream<PedestrianStatus>? pedestrianStatusStream,
    String? status,
    int? steps,
    DateTime? date,
    Map<int, int>? hourlySteps,
  }) {
    return StepsState(
      stepCountStream: stepCountStream ?? this.stepCountStream,
      pedestrianStatusStream: pedestrianStatusStream ?? this.pedestrianStatusStream,
      status: status ?? this.status,
      steps: steps ?? this.steps,
      date: date ?? this.date,
      hourlySteps: hourlySteps ?? this.hourlySteps,
    );
  }
}