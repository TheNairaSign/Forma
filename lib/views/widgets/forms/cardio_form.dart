import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:provider/provider.dart';
import 'package:workout_tracker/providers/workout_group_notifier.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';
import 'package:workout_tracker/views/widgets/custom_drop_down_button.dart';
import 'package:workout_tracker/views/widgets/group_form.dart';

class CardioForm extends ConsumerWidget {
  final int? initialDuration;
  final double? initialDistance;
  final String? initialIntensity;
  final int? initialHeartRate;

  const CardioForm({
    super.key,
    this.initialDuration,
    this.initialDistance,
    this.initialIntensity,
    this.initialHeartRate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutGroupProvider = Provider.of<WorkoutGroupNotifier>(context, listen: false);
    final intensity = ref.watch(workoutItemProvider.notifier).workoutIntensity;

    return Column(
      children: [
        GroupForm(
          controller: workoutGroupProvider.cardioDurationController,
          labelText: 'Workout Duration (minutes)',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) return 'Enter duration';
            if (int.parse(value) < 1) return 'Minimum 1 minute';
            if (int.parse(value) > 300) return 'Maximum 300 minutes';
            return null;
          },
        ),
        const SizedBox(height: 16),
        GroupForm(
          controller: workoutGroupProvider.cardioDistanceController,
          labelText: 'Distance (km)',
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
          validator: (value) {
            if (value == null || value.isEmpty) return 'Enter distance';
            if (double.parse(value) < 0) return 'Invalid distance';
            if (double.parse(value) > 100) return 'Distance too high';
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomDropdownButton(
          backgroundColor: Color(0xfffef2f2),
          borderColor: Colors.red,
          textColor: Colors.red,
          items: intensity, 
          hint: 'Intensity',
        ),
        const SizedBox(height: 16),
        GroupForm(
          controller: workoutGroupProvider.heartRateController,
          labelText: 'Average Heart Rate (bpm)',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) return null; // Optional
            if (int.parse(value) < 40) return 'Heart rate too low';
            if (int.parse(value) > 220) return 'Heart rate too high';
            return null;
          },
        ),
      ],
    );
  }
}
