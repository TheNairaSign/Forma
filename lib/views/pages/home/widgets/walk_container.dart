import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';
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
    final steps = ref.watch(stepsProvider).steps;
    return GestureDetector(
      onTap: () => Navigator.of(context).push(SlidePageRoute(page: StepsDetailsPage(currentSteps: steps,))),
      child: Container(
        padding: EdgeInsets.all(15),
        height: 130,
        decoration: BoxDecoration(color: Color(0xff7064e3), borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Keep it up buddy', style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white)),
                  Text('Target: 4000', style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white, fontSize: 18)),
                ]
              ),
            ),
            Lottie.asset('assets/lottie/walking-animation.json', height: 100, width: 100),
            StepsProgressIndicator(currentStep: steps, strokeColor: Colors.white, measurementUnit: 'Steps', textColor: Color(0xffbdb6ff)),
          ],
        ),
      ),
    );
  }
}
