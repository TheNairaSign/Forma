import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:provider/provider.dart';
import 'package:workout_tracker/constants.dart';
import 'package:workout_tracker/models/enums/workout_type.dart';
import 'package:workout_tracker/providers/workout_group_notifier.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/views/widgets/custom_drop_down_button.dart';
import 'package:workout_tracker/views/widgets/forms/workout_form_selector.dart';

class AddWorkoutContainer extends ConsumerStatefulWidget {
  const AddWorkoutContainer({super.key});

  @override
  ConsumerState<AddWorkoutContainer> createState() => _AddWorkoutContainerState();
}

class _AddWorkoutContainerState extends ConsumerState<AddWorkoutContainer> {
  
  @override
  Widget build(BuildContext context) {
    final _selectedWorkout = ref.watch(workoutItemProvider.notifier).selectedWorkoutTypeGetter;
    return SingleChildScrollView(
      child: Container(
        height: 600,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: bodyPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add Workout', style:  Theme.of(context).textTheme.headlineMedium),
            CustomDropdownButton(
              borderColor: Colors.black,
              backgroundColor: Colors.white,
              items: WorkoutType.values.map((type) => type.name).toList(),
              hint: _selectedWorkout.name,
              onChanged: (value) {
                if (value != null) {
                  final selectedType = WorkoutType.values.firstWhere((type) => type.name == value);
                  debugPrint('Selected workout type: $selectedType');
                  ref.read(workoutItemProvider.notifier).selectedWorkoutType = selectedType;
                  ref.read(workoutItemProvider.notifier).workoutNameValue = value;
                  setState(() {});
                }
              },
            ),
              const SizedBox(height: 10),
            WorkoutFormSelector(selectedWorkoutType: _selectedWorkout),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: GlobalColors.teal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),
                onPressed: () => Provider.of<WorkoutGroupNotifier>(context, listen: false).addWorkout(context, ref),
                child: Text('Add Workout', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black))
              ),
            )
          ],
        ),
        )  
    );
  }
}