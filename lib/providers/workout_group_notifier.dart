import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/models/enums/workout_group.dart';
import 'package:workout_tracker/models/workout/workout.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';
import 'package:workout_tracker/utils/alerts.dart';
import 'package:workout_tracker/views/widgets/forms/cardio_form.dart';
import 'package:workout_tracker/views/widgets/forms/flow_form.dart';
import 'package:workout_tracker/views/widgets/forms/repetition_form.dart';
import 'package:workout_tracker/views/widgets/forms/strength_form.dart';
import 'package:workout_tracker/views/widgets/forms/time_form.dart';

class WorkoutGroupNotifier extends ChangeNotifier {
  // Repetition Form Controllers
  final TextEditingController setsController = TextEditingController();
  final TextEditingController repsController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  // Time Form Controllers
  final TextEditingController minutesController = TextEditingController();
  final TextEditingController secondsController = TextEditingController();
  final TextEditingController timeBasedSetsController = TextEditingController();

  // Flow Form Controllers
  final TextEditingController durationController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String _selectedIntensity = 'Moderate';
  String get selectedIntensity => _selectedIntensity;
  set selectedIntensity(String value) {
    _selectedIntensity = value;
    notifyListeners();
  }

  // Strength Form Controllers
  final TextEditingController strengthSetsController = TextEditingController();
  final TextEditingController strengthRepsController = TextEditingController();
  final TextEditingController strengthWeightController = TextEditingController();
  final TextEditingController restTimeController = TextEditingController();

  // Cardio Form Controllers
  final TextEditingController cardioDistanceController = TextEditingController();
  final TextEditingController cardioDurationController = TextEditingController();
  final TextEditingController heartRateController = TextEditingController();
  String cardioIntensity = 'Moderate';



  // Form Values Getters
  Map<String, dynamic> getRepetitionValues() {
    return {
      'sets': int.tryParse(setsController.text) ?? 0,
      'reps': int.tryParse(repsController.text) ?? 0,
      'weight': double.tryParse(weightController.text) ?? 0.0,
    };
  }

  Map<String, dynamic> getTimeValues() {
    return {
      'minutes': int.tryParse(minutesController.text) ?? 0,
      'seconds': int.tryParse(secondsController.text) ?? 0,
      'sets': int.tryParse(timeBasedSetsController.text) ?? 0,
    };
  }

  Map<String, dynamic> getFlowValues() {
    return {
      'duration': int.tryParse(durationController.text) ?? 0,
      'intensity': selectedIntensity,
      'notes': notesController.text,
    };
  }

  Map<String, dynamic> getStrengthValues() {
    return {
      'sets': int.tryParse(strengthSetsController.text) ?? 0,
      'reps': int.tryParse(strengthRepsController.text) ?? 0,
      'weight': double.tryParse(strengthWeightController.text) ?? 0.0,
      'restTime': int.tryParse(restTimeController.text) ?? 0,
    };
  }

  Map<String, dynamic> getCardioValues() {
    return {
      'duration': int.tryParse(cardioDurationController.text) ?? 0,
      'distance': int.tryParse(cardioDistanceController.text) ?? 0,
      'intensity': cardioIntensity,
      'heartRate': int.tryParse(heartRateController.text) ?? 0,
    };
  }

  Widget buildForm(BuildContext context, WidgetRef ref) {
    final type = ref.watch(workoutItemProvider.notifier).selectedWorkoutTypeGetter;
    final workoutGroup = workoutGroupMap[type];
    switch (workoutGroup) {
      case WorkoutGroup.repetition:
        debugPrint('Repitition: $type');
        return RepetitionForm();
      case WorkoutGroup.time:
        debugPrint('Time: $type');
        return TimeForm();
      case WorkoutGroup.flow:
        debugPrint('Flow: $type');
        return FlowForm();
      case WorkoutGroup.strength:
        debugPrint('Strength: $type');
        return StrengthForm();
      case WorkoutGroup.cardio:
        debugPrint('Cardio: $type');
        return CardioForm();
      default: 
        debugPrint('None: $type');
        return SizedBox.shrink();
    }
  }


  Widget buildInfoContainer() {
    return Placeholder();
  }

  void addWorkout(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(workoutItemProvider.notifier);
    final type = provider.selectedWorkoutTypeGetter;
    final workoutGroup = workoutGroupMap[type];
    final workoutName = provider.selectedWorkoutTypeGetter.name[0].toUpperCase() + provider.workoutName.substring(1);
    debugPrint("WorkoutName: $workoutName");
    switch (workoutGroup) {
      case WorkoutGroup.repetition:
        try {
          final values = getRepetitionValues();
          final workout = Workout(
            name: workoutName,
            // workoutGroup: workoutGroup,
            sets: values['sets'],
            reps: values['reps'],
            weight: values['weight'],
          );
          ref.watch(workoutItemProvider.notifier).addWorkout(context, workout, WorkoutGroup.repetition);
        } catch (e) {
          debugPrint('Add repitition workout error: $e');
          Alerts.showErrorDialog(context, 'Error', 'Invalid Workout Type');
        } finally {
          resetRepetitionForm();
        }
        // break;
      case WorkoutGroup.time:
        try{
          final values = getTimeValues();
          final workout = Workout(
            name: workoutName,
            // workoutGroup: workoutGroup,
            goalDuration: values['minutes'],
            durationInSeconds: values['seconds'],
            sets: values['sets'],
          );
          ref.watch(workoutItemProvider.notifier).addWorkout(context, workout, WorkoutGroup.time);
        } catch (e) {
          debugPrint('Add time workout error: $e');
          Alerts.showErrorDialog(context, 'Error', 'Invalid Workout Type');
        } finally {
          resetTimeForm();
        }
        // break;
      case WorkoutGroup.flow:
        try {
          final values = getFlowValues();
          final workout = Workout(
            name: workoutName,
            // workoutGroup: workoutGroup,
            goalDuration: values['duration'],
            intensity: values['intensity'],
            description: values['notes'],
          ) ;
          ref.watch(workoutItemProvider.notifier).addWorkout(context, workout, WorkoutGroup.flow);
        } catch (e) {
          debugPrint('Add flow workout error: $e');
          Alerts.showErrorDialog(context, 'Error', 'Invalid Workout Type');
        } finally {
          resetFlowForm();
        }
        // break;
      case WorkoutGroup.strength:
        try {
          final values = getStrengthValues();
          final workout = Workout(
            name: workoutName,
            // workoutGroup: workoutGroup,
            sets: values['sets'],
            reps: values['reps'],
            weight: values['weight'],
            restTime: values['restTime'],
          );
          ref.watch(workoutItemProvider.notifier).addWorkout(context, workout, WorkoutGroup.strength);
        } catch (e) {
          debugPrint('Add strength workout error: $e');
          Alerts.showErrorDialog(context, 'Error', 'Invalid Workout Type');
        } finally {
          resetStrengthForm();
        }
        // break;
      case WorkoutGroup.cardio:
        try {
          final values = getCardioValues();
          final workout = Workout(
            name: workoutName,
            // workoutGroup: workoutGroup,
            goalDuration: values['duration'],
            distance: values['distance'],
            intensity: values['intensity'],
            heartRate: values['heartRate'],
          );
          ref.watch(workoutItemProvider.notifier).addWorkout(context, workout, WorkoutGroup.cardio);
          resetCardioForm();
        } catch (e) {
          debugPrint('Add cardio workout error: $e');
          Alerts.showErrorDialog(context, 'Error', 'Invalid Workout Type');
        } finally {
          resetCardioForm();
        }
        // break;
      default:
        debugPrint('None: $type');
        Alerts.showErrorDialog(context, 'Error', 'Invalid Workout Type');
        // break;
    }
    notifyListeners();
  }

  // Update Functions
  void updateIntensity(String intensity, WorkoutGroup group) {
    if (group == WorkoutGroup.flow) {
      selectedIntensity = intensity;
    } else if (group == WorkoutGroup.cardio) {
      cardioIntensity = intensity;
    }
    notifyListeners();
  }

  // Reset Functions
  void resetRepetitionForm() {
    setsController.clear();
    repsController.clear();
    weightController.clear();
    notifyListeners();
  }

  void resetTimeForm() {
    minutesController.clear();
    secondsController.clear();
    timeBasedSetsController.clear();
    notifyListeners();
  }

  void resetFlowForm() {
    durationController.clear();
    notesController.clear();
    selectedIntensity = 'Moderate';
    notifyListeners();
  }

  void resetStrengthForm() {
    strengthSetsController.clear();
    strengthRepsController.clear();
    strengthWeightController.clear();
    restTimeController.clear();
    notifyListeners();
  }

  void resetCardioForm() {
    cardioDistanceController.clear();
    cardioDurationController.clear();
    heartRateController.clear();
    cardioIntensity = 'Moderate';
    notifyListeners();
  }

  // Validation Functions
  bool validateRepetitionForm() {
    final sets = int.tryParse(setsController.text);
    final reps = int.tryParse(repsController.text);
    final weight = double.tryParse(weightController.text);

    return sets != null && sets > 0 && sets <= 10 &&
           reps != null && reps > 0 && reps <= 100 &&
           (weight == null || (weight >= 0 && weight <= 500));
  }

  bool validateTimeForm() {
    final minutes = int.tryParse(minutesController.text);
    final seconds = int.tryParse(secondsController.text);
    final sets = int.tryParse(timeBasedSetsController.text);

    return minutes != null && minutes >= 0 && minutes <= 180 &&
           seconds != null && seconds >= 0 && seconds <= 59 &&
           sets != null && sets > 0;
          //  && sets <= 20;
  }

  bool validateFlowForm() {
    final duration = int.tryParse(durationController.text);
    return duration != null && duration >= 5 && duration <= 120;
  }

  bool validateStrengthForm() {
    final sets = int.tryParse(strengthSetsController.text);
    final reps = int.tryParse(strengthRepsController.text);
    final weight = double.tryParse(strengthWeightController.text);
    final restTime = int.tryParse(restTimeController.text);

    return sets != null && sets > 0 && sets <= 10 &&
           reps != null && reps > 0 && reps <= 20 &&
           weight != null && weight > 0 && weight <= 500 &&
           restTime != null && restTime >= 30 && restTime <= 300;
  }

  bool validateCardioForm() {
    final duration = int.tryParse(cardioDurationController.text);
    final distance = double.tryParse(cardioDistanceController.text);
    final heartRate = int.tryParse(heartRateController.text);

    return duration != null && duration > 0 && duration <= 300 &&
           distance != null && distance > 0 && distance <= 100 &&
           (heartRate == null || (heartRate >= 40 && heartRate <= 220));
  }

  @override
  void dispose() {
    // Dispose all controllers
    setsController.dispose();
    repsController.dispose();
    weightController.dispose();
    minutesController.dispose();
    secondsController.dispose();
    timeBasedSetsController.dispose();
    durationController.dispose();
    notesController.dispose();
    strengthSetsController.dispose();
    strengthRepsController.dispose();
    strengthWeightController.dispose();
    restTimeController.dispose();
    cardioDistanceController.dispose();
    cardioDurationController.dispose();
    heartRateController.dispose();
    super.dispose();
  }
}