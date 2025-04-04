import 'package:flutter/material.dart';
import 'package:workout_tracker/views/pages/progress/widgets/weight_stats_widget.dart';
import 'package:workout_tracker/views/pages/progress/widgets/workout_goal_card.dart';
import 'package:workout_tracker/views/pages/progress/widgets/workout_goals_header.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 300,
              backgroundColor: Color(0xff080b10),
              foregroundColor: Colors.white,
              collapsedHeight: 60,
              centerTitle: true,
              floating: true,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
              pinned: true,
              snap: true,
              title: Text('Overall stat', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),),
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {},
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: WeightStatsWidget(),
              ),
            ),
            
            // Workout Goals Section
            SliverToBoxAdapter(child: WorkoutGoalsHeader()),
            
            // Workout Goal Cards
            SliverList(
              delegate: SliverChildListDelegate([
                WorkoutGoalCard(
                  title: 'Arm & shoulder muscle',
                  subtitle: '35 Exercise',
                  color: Colors.red.shade400,
                  icon: Icons.fitness_center_outlined,
                  percentage: 37,
                ),
                WorkoutGoalCard(
                  title: 'Hand grip muscle',
                  subtitle: '12 Exercise',
                  color: Colors.blue.shade400,
                  icon: Icons.back_hand_outlined,
                  percentage: 85,
                ),
                WorkoutGoalCard(
                  title: 'Leg muscle',
                  subtitle: '24 Exercise',
                  color: Colors.amber.shade400,
                  icon: Icons.directions_run_outlined,
                  percentage: 63,
                ),
                
                // Add some space at the bottom
                const SizedBox(height: 40),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}