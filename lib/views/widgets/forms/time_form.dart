import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/providers/workout_group_notifier.dart';
import 'package:workout_tracker/views/widgets/group_form.dart';

class TimeForm extends StatelessWidget {

  const TimeForm({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutGroupProvider = Provider.of<WorkoutGroupNotifier>(context, listen: false);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GroupForm(
                controller: workoutGroupProvider.minutesController,
                labelText: 'Minutes',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter minutes';
                  if (int.parse(value) < 0) return 'Invalid minutes';
                  if (int.parse(value) > 180) return 'Maximum 180 minutes';
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GroupForm(
                controller: workoutGroupProvider.timeBasedSetsController,
                labelText: 'Seconds',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter seconds';
                  if (int.parse(value) < 0) return 'Invalid seconds';
                  if (int.parse(value) > 59) return 'Maximum 59 seconds';
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GroupForm(
          controller: workoutGroupProvider.setsController,
          labelText: 'Number of Sets',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) return 'Enter sets';
            if (int.parse(value) < 1) return 'Minimum 1 set';
            if (int.parse(value) > 20) return 'Maximum 20 sets';
            return null;
          },
        ),
      ],
    );
  }
}