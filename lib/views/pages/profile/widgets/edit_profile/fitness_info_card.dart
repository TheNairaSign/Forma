import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/models/enums/fitness_level.dart';
import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/utils/alerts.dart';
import 'package:workout_tracker/views/widgets/custom_drop_down_button.dart';

class FitnessInfoCard extends ConsumerWidget {
  const FitnessInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final fitnessLevel = ref.read(profileDataProvider).value?.fitnessLevel;
    return Container(
      decoration: BoxDecoration(
        color: GlobalColors.primaryColorLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: GlobalColors.boxShadow(context)
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fitness Information',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: GlobalColors.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            CustomDropdownButton(
              items: FitnessLevel.values.map((value) => value.label).toList(),
              hint: fitnessLevel ?? 'Fitness level',
              backgroundColor: Colors.white,
              textColor: Colors.black,
              onChanged: (value) {
                if (value != null) {
                  ref.read(profileDataProvider.notifier).updateFitnessLevel(value);
                  Alerts.showFlushBar(context, 'Fitness Info changed to $value', false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}