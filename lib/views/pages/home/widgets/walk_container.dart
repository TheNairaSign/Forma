import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/utils/custom_route.dart';
import 'package:workout_tracker/views/pages/home/sub_pages/steps_details_page.dart';
import 'package:workout_tracker/views/pages/home/widgets/steps_progress_indicator.dart';

class WalkContainer extends ConsumerStatefulWidget  {
  const WalkContainer({super.key});

  @override
  ConsumerState<WalkContainer> createState() => _WalkContainerState();
}

class _WalkContainerState extends ConsumerState<WalkContainer> {

  @override
  Widget build(BuildContext context) {
    final targetSteps = ref.watch(stepsProvider.notifier).dailyTargetSteps;
    final steps = ref.watch(stepsProvider).steps;
    return GestureDetector(
      onTap: () => Navigator.of(context).push(SlidePageRoute(page: StepsDetailsPage(currentSteps: steps,))),
      child: Container(
        padding: EdgeInsets.all(15),
        height: 110,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            GlobalColors.primaryColor,
            GlobalColors.primaryColorLight,
          ]),
          borderRadius: BorderRadius.circular(15),
          boxShadow: GlobalColors.boxShadow(context)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Keep it\nup buddy', style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black)),
                Text('Target: $targetSteps', style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white, fontSize: 18)),
              ]
            ),
            Lottie.asset('assets/lottie/walking-animation.json', height: 100, width: 100),
            StepsProgressIndicator(
              currentSteps: steps, 
              strokeColor: Color(0xff1b3a4b),
              measurementUnit: 'Steps',
              textColor: Colors.white,
              targetValue: targetSteps,
            ),
          ],
        ),
      ),
    );
  }
}
