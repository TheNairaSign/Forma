// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:workout_tracker/providers/workout_item_notifier.dart';

// class AddWorkoutTextFieldModel {
//   final String label, hintText;
//   final TextEditingController controller;
//   final TextInputType keyboardType;

//   AddWorkoutTextFieldModel({
//     required this.label,
//     required this.hintText,
//     required this.controller,
//     this.keyboardType = TextInputType.text,
//   });

//   static List<AddWorkoutTextFieldModel> getWorkoutModels(WidgetRef ref) {
//     List<AddWorkoutTextFieldModel> models = [];
//     final workoutControllers = ref.read(workoutItemProvider.notifier);
//       models.add(
//         AddWorkoutTextFieldModel(
//           label: 'Sets',
//           hintText: 'Enter number of sets',
//           controller: workoutControllers.setsController,
//           keyboardType: TextInputType.number,
//         ),
//       );
//       models.add(
//         AddWorkoutTextFieldModel(
//           label: 'Reps',
//           hintText: 'Enter number of reps',
//           controller: workoutControllers.repsController,
//           keyboardType: TextInputType.number,
//         ),
//       );
//       models.add(
//         AddWorkoutTextFieldModel(
//           label: 'Motivation',
//           hintText: 'Enter motivation for this workout',
//           controller: workoutControllers.descController,
//         ),
//       );
//       models.add(
//         AddWorkoutTextFieldModel(
//           label: 'Target Rep Goal (opitional)',
//           hintText: 'Enter target reps goal ',
//           controller: workoutControllers.goalRepsController,
//           keyboardType: TextInputType.number,
//         ),
//       );
//       models.add(
//         AddWorkoutTextFieldModel(
//           label: 'Workout Duration',
//           hintText: 'Enter workout duration (in minutes)',
//           controller: workoutControllers.goalDurationController,
//           keyboardType: TextInputType.number,
//         ),
//       );
//     return models;
//   }
// }
