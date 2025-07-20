// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:workout_tracker/models/state/profile_data.dart';
// import 'package:workout_tracker/models/workout/workout.dart';
// import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';
// import 'package:workout_tracker/providers/workout_item_notifier.dart';

// final combinedDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
//   final profileData = await ref.read(profileDataProvider.notifier).loadProfileData();
//   final workoutItems = await ref.read(workoutItemProvider.notifier).getWorkoutsForDay(DateTime.now());

//   return {
//     'profileData': profileData,
//     'workoutItems': workoutItems,
//   };
// });
