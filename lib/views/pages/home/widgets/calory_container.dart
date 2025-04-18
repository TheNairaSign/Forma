import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:workout_tracker/providers/calories_provider.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';
import 'package:workout_tracker/utils/custom_route.dart';
import 'package:workout_tracker/views/pages/activity/activity_page.dart';
import 'package:workout_tracker/views/pages/home/widgets/steps_progress_indicator.dart';

class CaloryContainer extends ConsumerStatefulWidget  {
  const CaloryContainer({super.key});

  @override
  ConsumerState<CaloryContainer> createState() => _CaloriesContainerState();
}

class _CaloriesContainerState extends ConsumerState<CaloryContainer> {

  @override
  void initState() {
    super.initState();
    // ref.read(stepsProvider.notifier).initPlatformState();
  }
  @override
  Widget build(BuildContext context) {
    final steps = ref.watch(stepsProvider.notifier);
    debugPrint('Calory $steps');
    return GestureDetector(
      onTap: () => Navigator.of(context).push(SlidePageRoute(page: CalorieDetailsPage())),
      child: Container(
        padding: EdgeInsets.all(15),
        height: 130,
        // width: size * 0.4,
        decoration: BoxDecoration(
          color: Color(0xff6fffe9),
          borderRadius: BorderRadius.circular(15),
        ),
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
                  Text('Burning calories', style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black)),
                  Text('Keep it up', style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.grey, fontSize: 18)),
                ]
              ),
            ),
            Lottie.asset('assets/lottie/calory-animation.json', height: 100, width: 100),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                StepsProgressIndicator(
                  currentCalory: ref.watch(caloryProvider.notifier).todayTotal,
                  targetValue: 10,
                  strokeColor:  Color(0xff1b3a4b),
                  measurementUnit: 'Kcal',
                  textColor: Colors.grey,
                  circularDirection: CircularDirection.counterclockwise,
                ),
                // SizedBox(width: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
