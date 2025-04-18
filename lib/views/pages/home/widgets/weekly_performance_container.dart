import 'package:flutter/material.dart';

class WeeklyPerformanceContainer extends StatelessWidget {
  const WeeklyPerformanceContainer({super.key, required this.title, required this.day, required this.steps, required this.icon, required this.color});
  final String title, day, steps;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(day, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
        const Spacer(),
        Text(
          steps,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}