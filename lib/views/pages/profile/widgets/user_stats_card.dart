import 'package:flutter/material.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/views/pages/profile/widgets/user_stats_item.dart';

class UserStats extends StatelessWidget {
  const UserStats({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: GlobalColors.boxShadow(context),
        gradient: LinearGradient(colors: [
          Color(0xff2EC4B6),
          Color(0xffCBF3F0),
        ])
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                UserStatsItem(
                  value: '1,250',
                  label: 'Total Workouts',
                  icon: Icons.fitness_center,
                ),
                UserStatsItem(
                  value: '28',
                  label: 'Current Streak',
                  icon: Icons.local_fire_department,
                ),
                UserStatsItem(
                  value: '85%',
                  label: 'Consistency',
                  icon: Icons.trending_up,
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.65,
              backgroundColor: Colors.white,
              color: Color(0xff14213d),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly Goal: 5 workouts',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Color(0xff555b6e),
                  ),
                ),
                Text(
                  '3/5 completed',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff555b6e)
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}