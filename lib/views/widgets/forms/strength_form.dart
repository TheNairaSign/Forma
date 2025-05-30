import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/providers/workout_group_notifier.dart';
import 'package:workout_tracker/views/widgets/group_form.dart';

class StrengthForm extends StatelessWidget {

  const StrengthForm({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutGroupProvider = Provider.of<WorkoutGroupNotifier>(context, listen: false);

    return Column(
      children: [
        GroupForm(
          controller: workoutGroupProvider.strengthSetsController,
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
        GroupForm(
          controller: workoutGroupProvider.strengthRepsController,
          labelText: 'Repetitions per set',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter reps';
            if (int.parse(value) < 1) return 'Minimum 1 rep required';
            if (int.parse(value) > 20) return 'Maximum 20 reps for strength';
            return null;
          },
        ),
        const SizedBox(height: 16),
        GroupForm(
          controller: workoutGroupProvider.strengthWeightController,
          labelText: 'Weight (kg)',
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
          validator: (value) {
            if (value == null || value.isEmpty) return 'Weight required for strength';
            if (double.parse(value) < 0) return 'Weight cannot be negative';
            if (double.parse(value) > 500) return 'Weight seems too high';
            return null;
          },
        ),
        const SizedBox(height: 16),
        GroupForm(
          controller: workoutGroupProvider.restTimeController,
          labelText: 'Rest between sets (seconds)',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) return 'Enter rest time';
            if (int.parse(value) < 30) return 'Minimum 30 seconds rest';
            if (int.parse(value) > 300) return 'Maximum 300 seconds rest';
            return null;
          },
        ),
      ],
    );
  }
}