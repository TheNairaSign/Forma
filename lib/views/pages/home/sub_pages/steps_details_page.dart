import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/utils/constants.dart';
import 'package:workout_tracker/views/pages/home/widgets/chart_data.dart';
import 'package:workout_tracker/views/pages/home/widgets/weekly_activity_container.dart';
import 'package:workout_tracker/views/widgets/steps_estimate_container.dart';

class StepsDetailsPage extends ConsumerStatefulWidget {
  const StepsDetailsPage({super.key, required this.currentSteps});
  final int currentSteps;

  @override
  ConsumerState<StepsDetailsPage> createState() => _StepsDetailsPageState();
}

class _StepsDetailsPageState extends ConsumerState<StepsDetailsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const ChartDataContainer(),
          SliverToBoxAdapter(
            child: Padding(
              padding: Constants.bodyPadding.copyWith(top: 10),
              child: Column(
                children: [
                  StepsEstimateContainer(),
                  const SizedBox(height: 10),
                  WeeklyActivityContainer(),
                ]
              ),
            ),
          ),
        ],
      ),
    );
  }

}