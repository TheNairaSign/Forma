import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/providers/workout_group_notifier.dart';
import 'package:workout_tracker/views/widgets/group_form.dart';

class RepetitionForm extends StatelessWidget {

  const RepetitionForm({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutGroupProvider = context.read<WorkoutGroupNotifier>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text('Sets', style: Theme.of(context).textTheme.bodyMedium),
        GroupForm(
          controller: workoutGroupProvider.setsController,
          labelText: 'Sets',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter sets';
            if (int.parse(value) < 1) return 'Minimum 1 set required';
            if (int.parse(value) > 10) return 'Maximum 10 sets allowed';
            return null;
          },
        ),
        const SizedBox(height: 16),
        // Text('Sets', style: Theme.of(context).textTheme.bodyMedium),
        // const SizedBox(height: 10),
        GroupForm(
          controller: workoutGroupProvider.repsController,
          labelText: 'Repetitions per set',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter reps';
            if (int.parse(value) < 1) return 'Minimum 1 rep required';
            if (int.parse(value) > 100) return 'Maximum 100 reps allowed';
            return null;
          },
        ),
        const SizedBox(height: 16),
        GroupForm(
          controller: workoutGroupProvider.weightController,
          labelText: 'Weight (kg)',
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
          validator: (value) {
            if (value == null || value.isEmpty) return null; // Weight is optional
            if (double.parse(value) < 0) return 'Weight cannot be negative';
            if (double.parse(value) > 500) return 'Weight seems too high';
            return null;
          },
        ),
      ],
    );
  }
}