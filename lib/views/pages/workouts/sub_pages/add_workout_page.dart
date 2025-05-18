import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/constants.dart';
import 'package:workout_tracker/models/add_workout_model.dart';
import 'package:workout_tracker/models/enums/workout_type.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';
import 'package:workout_tracker/services/workout_service.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/views/widgets/custom_drop_down_button.dart';
import 'package:workout_tracker/views/widgets/custom_text_field.dart';

class AddWorkoutPage extends ConsumerStatefulWidget {
  const AddWorkoutPage({super.key});

  @override
  ConsumerState<AddWorkoutPage> createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends ConsumerState<AddWorkoutPage> {

  List<AddWorkoutTextFieldModel> workouts = [];
  final workoutService = WorkoutService();

  void initializeWorkouts() => workouts = AddWorkoutTextFieldModel.getWorkoutModels(ref);

  @override
  void initState() {
    super.initState();
    initializeWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Workout'),
      ),
      body: Padding(
        padding: bodyPadding,
        child: ListView(
          children: [
            Text('Workout Name', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black)),
            const SizedBox(height: 10),
            CustomDropdownButton(
              backgroundColor: Color(0xffeeeef0),
              items: WorkoutType.values.map((type) => type.name).toList(), hint: 'Pick a workout', onChanged: (p0) => ref.watch(workoutItemProvider.notifier).workoutNameValue = p0!,),
              const SizedBox(height: 10),
            ...List.generate(workouts.length, (index) {
              final workout = workouts[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(workout.label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black)),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CustomTextField(controller: workout.controller, hintText: workout.hintText, keyboardType: workout.keyboardType),
                  ),
                ],
              );
            }),
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: GlobalColors.teal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),
                onPressed: () => ref.read(workoutItemProvider.notifier).addWorkout(context),
                child: Text('Add Workout', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black))
              ),
            )
          ],
        ),
      )
    );
  }
}