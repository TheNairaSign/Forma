import 'package:flutter/material.dart';
import 'package:workout_tracker/views/pages/profile/widgets/achievements/achievement_badge.dart';

class AchievementSection extends StatelessWidget {
  const AchievementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Achievements',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              AchievementBadge(
                iconPath: 'assets/svgs/medal-badge.svg',
                title: '30-Day Streak',
                unlocked: true,
              ),
              const SizedBox(width: 12),
              AchievementBadge(
                iconPath: 'assets/svgs/trophy.svg',
                title: 'First 5K',
                unlocked: true,
              ),
              const SizedBox(width: 12),
              AchievementBadge(
                iconPath: 'assets/svgs/weight.svg',
                title: '100kg Bench',
                unlocked: false,
              ),
              const SizedBox(width: 12),
              AchievementBadge(
                iconPath: 'assets/svgs/yoga.svg',
                title:  'Flexibility',
                unlocked: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}