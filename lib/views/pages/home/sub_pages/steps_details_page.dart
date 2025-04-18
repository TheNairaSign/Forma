import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/utils/constants.dart';
import 'package:workout_tracker/views/pages/home/widgets/chart_data.dart';
import 'package:workout_tracker/views/pages/home/widgets/steps_counter_widget.dart';
import 'package:workout_tracker/views/pages/home/widgets/weekly_activity_container.dart';
import 'package:workout_tracker/views/widgets/animated_page_entry.dart';

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
      appBar: AppBar(title: Text('Step Counter', style: Theme.of(context).textTheme.headlineSmall), centerTitle: true,),
      body: Padding(
        padding: Constants.bodyPadding,
        child: AnimatedPageEntry(
          children: [
            StepCounterWidget(caloriesBurned: 870, progressColor: Color(0xFF4CD964)),
            const SizedBox(height: 10),
            ChartDataContainer(),
            const SizedBox(height: 10),
            WeeklyActivityContainer(),
            
          ]
        ),
      )
    );
  }

}