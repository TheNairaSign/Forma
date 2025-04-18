import 'package:flutter/material.dart';
import 'package:workout_tracker/style/global_colors.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({super.key, required this.title, required this.value, required this.icon});
  final String title, value; 
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme =  Theme.of(context);
    return Expanded(
      child: Card(
        color: Color(0xffc4fff9),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: Colors.black),
                  const SizedBox(width: 8),
                  Text(title, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[900])),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: GlobalColors.textThemeColor(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}