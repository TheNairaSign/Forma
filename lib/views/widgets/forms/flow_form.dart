import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:provider/provider.dart';
import 'package:workout_tracker/providers/workout_group_notifier.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';
import 'package:workout_tracker/views/widgets/custom_drop_down_button.dart';
import 'package:workout_tracker/views/widgets/group_form.dart';

class FlowForm extends ConsumerWidget {

  const FlowForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutGroupProvider = Provider.of<WorkoutGroupNotifier>(context, listen: false);
    final intensity = ref.watch(workoutItemProvider.notifier).workoutIntensity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GroupForm(
          controller: workoutGroupProvider.durationController,
          labelText: 'Workout Duration (minutes)',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) return 'Enter duration';
            if (int.parse(value) < 5) return 'Minimum 5 minutes';
            if (int.parse(value) > 120) return 'Maximum 120 minutes';
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomDropdownButton(
          items: intensity, 
          hint: 'Workout Intensity',
          backgroundColor: Color(0xfffef2f2),
          textColor: Colors.red,
          borderColor: Colors.red,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 60,
          child: GroupForm(
            controller: workoutGroupProvider.notesController,
            keyboardType: TextInputType.text,
            labelText: 'Notes (Optional)',
            maxLines: 3,
            maxLength: 200,
          ),
        ),
      ],
    );
  }
}