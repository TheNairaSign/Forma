import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/models/add_workout_model.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';
import 'package:workout_tracker/services/workout_service.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/views/widgets/custom_text_field.dart';

class AddWorkoutContainer extends ConsumerStatefulWidget {
  const AddWorkoutContainer({super.key});

  @override
  ConsumerState<AddWorkoutContainer> createState() => _AddWorkoutContainerState();
}

class _AddWorkoutContainerState extends ConsumerState<AddWorkoutContainer> {
  List<AddWorkoutTextFieldModel> workouts = [];
  final workoutService = WorkoutService();

  void initializeWorkouts() {
    workouts = AddWorkoutTextFieldModel.getWorkoutModels(ref);
  }

  @override
  void initState() {
    super.initState();
    initializeWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Text('Add Workout', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          ...List.generate(workouts.length, (index) {
            final workout = workouts[index];
            return CustomTextField(controller: workout.controller, labelText: workout.label, hintText: workout.hintText, keyboardType: workout.keyboardType);
          }),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: GlobalColors.teal,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              ),
              onPressed: () => ref.read(workoutItemProvider.notifier).addWorkout(context),
              child: Text('Add Workout', style: Theme.of(context).textTheme.bodyMedium)
            ),
          )
        ],
      )  
    );
  }
}