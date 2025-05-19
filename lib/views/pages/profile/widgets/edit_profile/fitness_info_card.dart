import 'package:flutter/material.dart';
import 'package:workout_tracker/models/enums/fitness_level.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/views/widgets/custom_drop_down_button.dart';

class FitnessInfoCard extends StatelessWidget {
  const FitnessInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: GlobalColors.primaryColorLight,
        // color: Color(0xffb2f7ef),
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
              items: FitnessLevel.values.map((value) => value.name).toList(), 
              hint: 'Fitness level',
              backgroundColor: Colors.white,
              textColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}