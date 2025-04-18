import 'package:flutter/material.dart';

class NutritionTipContainer extends StatelessWidget {
  const NutritionTipContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Color(0xffd91b1b),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.yellow,
                ),
                const SizedBox(width: 8),
                Text(
                  'Nutrition Tip',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.yellow),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'After intense workouts, replenish with a balanced meal containing '
              'protein for muscle recovery and carbohydrates to restore energy. '
              'Aim for a 3:1 ratio of carbs to protein within 30 minutes post-workout.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}