// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/views/pages/home/widgets/weekly_performance_container.dart';

class WeeklyActivityContainer extends ConsumerStatefulWidget {
  const WeeklyActivityContainer({super.key});

  @override
  ConsumerState<WeeklyActivityContainer> createState() => _WeeklyActivityContainerState();
}

class _WeeklyActivityContainerState extends ConsumerState<WeeklyActivityContainer> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(stepsProvider.notifier);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: GlobalColors.boxShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DateSelectionWidget(),\
          const SizedBox(height: 20),
          const Text('Weekly Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].asMap().entries.map((entry) {
              final weeklyData = provider.getWeeklySteps();
              final daySteps = entry.key < weeklyData.length ? weeklyData[entry.key].steps : 0;
              final progress = daySteps / provider.dailyTargetSteps;
              
              return Column(
                children: [
                  Container(
                    width: 8,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 8,
                          height: 40 * progress.clamp(0.0, 1.0),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(entry.value, style: TextStyle(color: Colors.grey[600])),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          WeeklyPerformanceContainer(
            title :'Best Performance',
            day: 'Monday',
            steps: provider.highestWeeklyStep.toString(),
            icon: Icons.sentiment_satisfied_alt,
            color: Colors.orange,
          ),
          const SizedBox(height: 20),
          WeeklyPerformanceContainer(
            title: 'Worst Performance',
            day: 'Wednesday',
            steps: provider.lowestWeeklyStep.toString(),
            icon: Icons.sentiment_dissatisfied,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}