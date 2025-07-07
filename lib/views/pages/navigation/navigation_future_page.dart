import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';
import 'package:workout_tracker/views/pages/navigation/navigation_page.dart';

class NavigationFuturePage extends ConsumerWidget {
  const NavigationFuturePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileDataFuture = ref.watch(profileDataProvider.notifier).loadProfileData();
    final workoutItemsFuture = ref.watch(workoutItemProvider.notifier).getWorkoutsForDay(DateTime.now());

    return FutureBuilder(
      future: Future.wait([profileDataFuture, workoutItemsFuture]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Error loading data'),
            ),
          );
        } else {
          return const NavigationPage();
        }
      },
    );
  }
}
