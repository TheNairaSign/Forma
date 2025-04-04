import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';
import 'package:workout_tracker/views/pages/home/widgets/activity_item.dart';
import 'package:workout_tracker/views/pages/home/widgets/calory_container.dart';

class ActivityContainer extends ConsumerWidget {
  ActivityContainer({super.key});

  final colors = [Colors.amber, Colors.teal, Colors.blueAccent];

  final muscles = [
    "Biceps, triceps, shoulders",
    "Calves, legs, thighs",
    "Calves, hamstrings, glutes",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(workoutItemProvider);
    // final double height = 170;
    return activities.isEmpty ?
    Center(child: Text('No recent activities', style:  Theme.of(context).textTheme.bodyLarge,),)
    : Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CaloryContainer(),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(activities.length > 3 ? 3 : activities.length, (index) {
                  final activity = activities[index];
                  return ActivityItem(
                    activity: activity.name,
                    sets: activity.sets.toString(),
                    littleContainerColor: colors[index],
                    muscles: muscles[index],
                    reps: activity.reps.toString(),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
