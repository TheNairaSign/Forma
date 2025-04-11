import 'package:pedometer/pedometer.dart';

class StepsState {
  Stream<StepCount> stepCountStream;
  Stream<PedestrianStatus> pedestrianStatusStream;
  int steps;
  String status;
  final DateTime date;

  StepsState({
    required this.stepCountStream,
    required this.pedestrianStatusStream,
    required this.status,
    required this.steps,
    required this.date,
  });

  StepsState copyWith({
    Stream<StepCount>? stepCountStream,
    Stream<PedestrianStatus>? pedestrianStatusStream,
    String? status,
    int? steps,
    DateTime? date,
  }) {
    return StepsState(
      stepCountStream: stepCountStream ?? this.stepCountStream,
      pedestrianStatusStream: pedestrianStatusStream ?? this.pedestrianStatusStream,
      status: status ?? this.status,
      steps: steps ?? this.steps,
      date: date?? this.date,
    );
  }
}