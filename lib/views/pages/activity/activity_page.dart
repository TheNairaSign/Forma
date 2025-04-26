import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/constants.dart';
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
    final backgroundColor =  Color(0xff080b10);
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 460,
            floating: false,
            pinned: true,
            centerTitle: true,
            title: Text('Activities', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
            foregroundColor: Colors.white,
            collapsedHeight: 60,
            backgroundColor: backgroundColor,
            // toolbarHeight: 400,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                margin: const EdgeInsets.fromLTRB(0, kToolbarHeight + 25 , 0, 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: backgroundColor),
                child: Column(
                  // physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    // Text('Weekly Overview', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
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
                    WeeklyChartContainer(calorieData: calorieData, backgroundColor: backgroundColor,),
                  ]
                )
              )
            )
          ),        
          SliverToBoxAdapter(
            child: Padding(
              padding: bodyPadding,
              child: Column(
                children: [
                  DailyBreakdown(calorieData: calorieData),
                  const SizedBox(height: 24),
                  NutritionTipContainer(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}