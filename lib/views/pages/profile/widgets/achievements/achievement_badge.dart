import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AchievementBadge extends StatelessWidget {
  const AchievementBadge({super.key, required this.iconPath, required this.title, required this.unlocked});
  final String iconPath, title; 
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: unlocked
                ? theme.colorScheme.primary.withOpacity(0.1)
                : theme.colorScheme.surfaceVariant,
            shape: BoxShape.circle,
            border: Border.all(
              color: unlocked
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              width: 32,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: unlocked
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withOpacity(0.3),
            fontWeight: unlocked ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}