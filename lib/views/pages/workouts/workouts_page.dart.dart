import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';
import 'package:workout_tracker/utils/alerts.dart';
import 'package:workout_tracker/utils/constants.dart';
import 'package:workout_tracker/views/pages/workouts/sub_pages/add_workout_page.dart';
import 'package:workout_tracker/views/pages/workouts/widgets/workout_item.dart';

class WorkoutsPage extends ConsumerStatefulWidget {
  const WorkoutsPage({super.key});

  @override
  ConsumerState<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends ConsumerState<WorkoutsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(workoutItemProvider.notifier).getWorkouts();
    });
  }

  @override
  Widget build(BuildContext context) {

    final workouts = ref.watch(workoutItemProvider);
    debugPrint('Build level Workouts: ${workouts.length} : $workouts');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Your Workouts', style: Theme.of(context).textTheme.headlineSmall),
        actionsPadding: EdgeInsets.only(right: 5),
        actions: [ IconButton(icon: Icon(Icons.add), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const AddWorkoutPage()))) ]),
      body: Padding(
        padding: Constants.bodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (workouts.isNotEmpty) ... [
                  const Spacer(),
                  TextButton.icon(
                    iconAlignment: IconAlignment.end,
                    icon: Icon(Icons.clear, color: Colors.red),
                    onPressed: () {
                      Alerts.areYouSureDialog(
                        context, 
                        () => ref.watch(workoutItemProvider.notifier).clearWorkouts(context), 
                        'Are you sure you want to clear all workouts?',
                      );
                    }, 
                    label: Text('Clear', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red, fontWeight: FontWeight.bold)),
                  )
                ]
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child:
                workouts.isEmpty
                  ? Center(child: Text('No workouts yet!', style: Theme.of(context).textTheme.bodyMedium,))
                  : ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      final workout = workouts[index];
                      return GestureDetector(
                        // onTap: () => Navigator.of(context).push(SlidePageRoute(page: WorkoutSessionScreen(workout: workout, index))),
                        child: AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 450),
                          child: SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(child: WorkoutItem(workout: workout)),  
                          )
                        )
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
