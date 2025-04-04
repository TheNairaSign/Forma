import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';
import 'package:workout_tracker/utils/constants.dart';
import 'package:workout_tracker/utils/custom_route.dart';
import 'package:workout_tracker/views/pages/workouts/sub_pages/workout_screen.dart';
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
    final workoutProvider = ref.watch(workoutItemProvider.notifier);
    debugPrint('Build level Workouts: ${workouts.length} : $workouts');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Workouts Page', style: Theme.of(context).textTheme.headlineSmall),
        actionsPadding: EdgeInsets.only(right: 5),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => workoutProvider.showAddWorkoutModal(context),
          ),
      ],),
      body: Padding(
        padding: Constants.bodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Workouts', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 20)),
            const SizedBox(height: 10),
            Expanded(
              child:
                workouts.isEmpty
                  ? Center(child: Text('No workouts yet!', style: Theme.of(context).textTheme.bodyMedium,))
                  : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      final workout = workouts[index];
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(SlidePageRoute(page: WorkoutSessionScreen(workout: workout, index))),
                        child: WorkoutItem(workout: workout));
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
