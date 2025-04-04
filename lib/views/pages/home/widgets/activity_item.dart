import 'package:flutter/material.dart';

class ActivityItem extends StatelessWidget {
  const ActivityItem({
    super.key,
    required this.activity,
    required this.sets,
    required this.reps,
    required this.muscles, 
    required this.littleContainerColor,
  });
  final String activity;
  final String sets, reps;
  final String muscles;
  final Color littleContainerColor;

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 15,
          width: 7,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: littleContainerColor),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(activity,style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
            Text(muscles, style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(reps, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(width: 5),
            Text('x$sets', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}