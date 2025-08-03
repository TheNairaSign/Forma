// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/hive/daily_steps_adapter.dart';
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
  
  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return 'Unknown';
    }
  }
  
  Widget _buildWeeklySummary(List<DailySteps> weeklyData) {
    int totalSteps = 0;
    int daysWithActivity = 0;
    
    for (var day in weeklyData) {
      totalSteps += day.steps;
      if (day.steps > 0) daysWithActivity++;
    }
    
    double averageSteps = daysWithActivity > 0 ? totalSteps / daysWithActivity : 0;
    
    // Calculate weekly goal progress (assuming weekly goal is 7 * daily target)
    final provider = ref.watch(stepsProvider.notifier);
    final weeklyGoal = provider.dailyTargetSteps * 7;
    final weeklyProgress = (totalSteps / weeklyGoal).clamp(0.0, 1.0);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weekly Summary', 
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _summaryItem('Total Steps', totalSteps.toString()),
              _summaryItem('Active Days', '$daysWithActivity/7'),
              _summaryItem('Daily Average', averageSteps.toStringAsFixed(0)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Weekly Goal', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                        Text('${(weeklyProgress * 100).toStringAsFixed(0)}%', 
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: _getProgressColor(weeklyProgress)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Stack(
                      children: [
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: weeklyProgress,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: _getProgressColor(weeklyProgress),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Color _getProgressColor(double progress) {
    if (progress < 0.3) return Colors.red;
    if (progress < 0.7) return Colors.orange;
    return Colors.green;
  }
  
  Widget _summaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(stepsProvider.notifier);
    final weeklyData = provider.getWeeklySteps().toList();
    
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
          // DateSelectionWidget(),
          const SizedBox(height: 20),
          Text('Weekly Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].asMap().entries.map((entry) {
              final daySteps = entry.key < weeklyData.length ? weeklyData[entry.key].steps : 0;
              final progress = daySteps / provider.dailyTargetSteps;
              final isHighest = daySteps == provider.highestWeeklyStep && daySteps > 0;
              final isLowest = daySteps == provider.lowestWeeklyStep && daySteps > 0;
              
              return Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: 12,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      Container(
                        width: 12,
                        height: 80 * progress.clamp(0.0, 1.0),
                        decoration: BoxDecoration(
                          color: isHighest ? Colors.orange : (isLowest && daySteps > 0 ? Colors.red : Colors.blue.shade300),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                      if (isHighest)
                        Positioned(
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.star, color: Colors.white, size: 8),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(entry.value, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  Text(
                    daySteps.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: Colors.grey[600],
                      fontWeight: isHighest || isLowest ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              WeeklyPerformanceContainer(
                title: 'Best Performance',
                day: provider.bestPerformingDayData != null
                    ? _getDayName(provider.bestPerformingDayData!.date.weekday)
                    : 'N/A',
                steps: '${provider.highestWeeklyStep} steps',
                icon: Icons.sentiment_satisfied_alt,
                color: Colors.orange,
              ),
              const SizedBox(height: 20),
              WeeklyPerformanceContainer(
                title: 'Worst Performance',
                day: provider.worstPerformingDayData != null
                    ? _getDayName(provider.worstPerformingDayData!.date.weekday)
                    : 'N/A',
                steps: '${provider.lowestWeeklyStep} steps',
                icon: Icons.sentiment_dissatisfied,
                color: Colors.red,
              ),
              const SizedBox(height: 20),
              _buildWeeklySummary(weeklyData),
            ],
          ),
        ],
      ),
    );
  }
}