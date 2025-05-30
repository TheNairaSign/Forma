import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';
import 'package:workout_tracker/views/pages/home/widgets/calory_container.dart';
import 'package:workout_tracker/views/pages/home/widgets/overall_status_container.dart';
import 'package:workout_tracker/views/pages/home/widgets/progress_container.dart';
import 'package:workout_tracker/views/pages/home/widgets/walk_container.dart';
import 'package:workout_tracker/views/widgets/animated_page_entry.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  @override
  void initState() {
    super.initState();
    ref.read(stepsProvider.notifier)
    ..initPlatformState(context)
    ..getTodaySteps();
  }

  @override
  Widget build(BuildContext context) {
    final steps = ref.watch(stepsProvider).steps;
    debugPrint('Steps $steps');
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          height: 30,
          width: 30,
          // padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(left: 20),
          child: CircleAvatar()),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome Back", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54)),
            Text("Nicolas Doflamingo",style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
        actionsPadding: EdgeInsets.only(right: 20),
        actions: [ IconButton(icon: Icon(Icons.notifications, color: Colors.black), onPressed: () {}) ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: AnimatedPageEntry(
          duration: Duration(milliseconds: 500),
          children: [

            ProgressContainer(),
            SizedBox(height: 20),

            // Today's Activity
            Text("Today's Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            WalkContainer(),
            const SizedBox(height: 20),
            CaloryContainer(),
            const SizedBox(height: 20),

            // Overall Status
            Text("Overall Status", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            OverallStatusContainer(),
          ],
        ),
      ),
    );
  }
}
