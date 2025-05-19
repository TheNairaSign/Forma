import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/services/workout_service.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/views/pages/profile/widgets/user_stats_item.dart';

class UserStats extends ConsumerStatefulWidget {
  const UserStats({super.key});

  @override
  ConsumerState<UserStats> createState() => _UserStatsState();
}

class _UserStatsState extends ConsumerState<UserStats> with SingleTickerProviderStateMixin  {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  Future<String> workoutCount() async {
    final workoutService = WorkoutService();
    final workoutCount = await workoutService.getWorkoutStatistics();
    debugPrint('workoutCount: $workoutCount');
    return workoutCount['overallWorkouts'].toString();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: GlobalColors.boxShadow(context),
            color: Colors.black,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<String>(
                      future: workoutCount(),
                      builder: (context, snapshot) {
                        return UserStatsItem(
                          value: snapshot.data ?? '0',  
                          label: 'Total Workouts',
                          icon: Icons.fitness_center,
                        );
                      },
                    ),
                    UserStatsItem(
                      value: '28',
                      label: 'Current Streak',
                      icon: Icons.local_fire_department,
                    ),
                    UserStatsItem(
                      value: '85%',
                      label: 'Consistency',
                      icon: Icons.trending_up,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: 0.65,
                  backgroundColor: Colors.white,
                  color: Colors.grey[700],
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Weekly Goal: 5 workouts',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
                    ),
                    Text(
                      '3/5 completed',
                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}