import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/providers/calories_provider.dart';
import 'package:workout_tracker/views/pages/activity/widgets/daily_breakdown.dart';
import 'package:workout_tracker/views/pages/activity/widgets/nutrition_tip_container.dart';
import 'package:workout_tracker/views/pages/activity/widgets/stat_card.dart';
import 'package:workout_tracker/views/pages/activity/widgets/weekly_chart_container.dart';

class CalorieDetailsPage extends ConsumerStatefulWidget {

  const CalorieDetailsPage({super.key});

  @override
  ConsumerState<CalorieDetailsPage> createState() => _CalorieDetailsPageState();
}

class _CalorieDetailsPageState extends ConsumerState<CalorieDetailsPage> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final calorieData = ref.read(caloryProvider.notifier).weeklyCaloryChartData();

    final todayIndex = DateTime.now().weekday - 1;
    final todayCalories = todayIndex < calorieData.length ? calorieData[todayIndex] : 0;
    final weeklyAverage = calorieData.isNotEmpty 
        ? calorieData.reduce((a, b) => a + b) ~/ calorieData.length 
        : 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Calorie Details'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Text('Weekly Overview', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                StatsCard(
                  title: 'Today',
                  value: '$todayCalories kcal',
                  icon: Icons.local_fire_department,
                ),
                const SizedBox(width: 12),
                StatsCard(
                  title: 'Weekly Avg',
                  value: '$weeklyAverage kcal',
                  icon: Icons.timeline,
                ),
              ],
            ),
            const SizedBox(height: 24),
            WeeklyChartContainer(calorieData: calorieData),
            const SizedBox(height: 24),
            DailyBreakdown(calorieData: calorieData),
            const SizedBox(height: 24),
            NutritionTipContainer(),
          ],
        ),
      ),
    );
  }
}