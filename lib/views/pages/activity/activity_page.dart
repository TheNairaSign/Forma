import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/providers/calories_provider.dart';
import 'package:workout_tracker/utils/get_week_days.dart';
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
  late List<Future<int>> _calo;

  
  @override
  void initState() {
    super.initState();
    // getWeeklyTotals is now async, so we'll handle it differently
    _loadWeeklyTotals();
  }

  Future<void> _loadWeeklyTotals() async {
    await ref.read(caloryProvider.notifier).getWeeklyTotals();
  }

  Future<void> _loadCaloriesForDay() async {
    final weekDays = getWeekDays();
    _calo = weekDays.map((date) async => await ref.read(caloryProvider.notifier).getCalorieForDay(date)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = Color(0xff080b10);
    
    // Use FutureBuilder to handle the async data loading
    return FutureBuilder<List<int>>(
      future: ref.read(caloryProvider.notifier).getWeeklyCalories(),
      builder: (context, snapshot) {
        // Show loading indicator while data is being fetched
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        final calorieData = snapshot.data!;
        final todayIndex = DateTime.now().weekday - 1;
        final todayCalories = todayIndex < calorieData.length ? calorieData[todayIndex] : 0;
        final weeklyAverage = calorieData.isNotEmpty 
            ? calorieData.reduce((a, b) => a + b) ~/ calorieData.length 
            : 0;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 460,
            floating: false,
            pinned: true,
            foregroundColor: Colors.white,
            backgroundColor: backgroundColor,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final top = constraints.biggest.height;
                final statusBar = MediaQuery.of(context).padding.top;
                final isCollapsed = top <= kToolbarHeight + statusBar;
                
                return FlexibleSpaceBar(
                  collapseMode: isCollapsed ? CollapseMode.parallax : CollapseMode.pin,
                  title: isCollapsed ? Text('Daily Breakdown', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)) : null,
                  centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 16.0, left: 16.0),
                  background: Container(
                    margin: const EdgeInsets.fromLTRB(0, kToolbarHeight + 15 , 0, 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: backgroundColor),
                    child: Column(
                      // physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Text('Weekly Overview', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
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
                  ),
                );
              }
            )
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text("Daily Breakdown", style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: backgroundColor)),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),   
          // DailyBreakdown already uses FutureBuilder internally for each day
          DailyBreakdown(calorieData: calorieData),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
              child: Column(
                children: [
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
    );
  }
}