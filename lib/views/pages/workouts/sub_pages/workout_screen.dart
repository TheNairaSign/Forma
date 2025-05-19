// // lib/screens/workout_session_screen.dart

// import 'package:circular_countdown_timer/circular_countdown_timer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:workout_tracker/models/workout/workout.dart';
// import 'package:workout_tracker/providers/workout_notifier.dart';
// import 'package:workout_tracker/views/pages/workouts/widgets/countdown_timer.dart';

// class WorkoutSessionScreen extends ConsumerStatefulWidget {
//   final Workout workout;
//   final int index;

//   const WorkoutSessionScreen(this.index, {super.key, required this.workout});

//   @override
//   ConsumerState<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
// }

// class _WorkoutSessionScreenState extends ConsumerState<WorkoutSessionScreen> {
//   final CountDownController _controller = CountDownController();

//   @override
//   void initState() {
//     super.initState();
//     ref.read(workoutProvider(widget.workout).notifier).initState(widget.index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final workoutNotifier = ref.watch(workoutProvider(widget.workout).notifier);
//     final workout = ref.watch(workoutProvider(widget.workout));
//     final elapsedSeconds = ref.read(workoutProvider(widget.workout).notifier).elapsedSeconds ?? 0;

//     debugPrint('Goal controller text: $elapsedSeconds');

//     return Scaffold(
//       appBar: AppBar(title: Text('${workout.name} Workout', style: Theme.of(context).textTheme.bodyLarge,)),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           if (workout.description != null)
//             Padding(
//               padding: const EdgeInsets.only(bottom: 16.0),
//               child: Text(workout.description!, textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
//             ),
      
//           // Watch elapsedSeconds directly from the provider
//           CountdownTimer(
//             // duration: elapsedSeconds.isNotEmpty ? int.parse(elapsedSeconds) : 0,
//             duration: elapsedSeconds,
//             controller: _controller,
//             isRunning: !workoutNotifier.isPaused,
//           ),
//           SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       if (workoutNotifier.isPaused) { 
//                         workoutNotifier.startWorkout(widget.index);
//                         if(_controller.isStarted.value) {
//                           debugPrint('Resumed Controller');
//                           workoutNotifier.resumeWorkout(elapsedSeconds);
//                           _controller.resume();
//                         } else {
//                           debugPrint('Started Controller');
//                           _controller.start();
//                         }
//                       } else {
//                         workoutNotifier.pauseWorkout();
//                         _controller.pause();
//                       }
//                     });
//                   },
//                   child: Container(
//                     height: 50,
//                     width: 50,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(25),
//                       border: Border.all(color: workoutNotifier.isPaused? Colors.green: Colors.yellow, width: 2),
//                     ),
//                     child: Icon(
//                       workoutNotifier.isPaused? Icons.play_arrow : Icons.pause, 
//                       color: workoutNotifier.isPaused? Colors.green: Colors.yellow, 
//                     )
//                   ),
//                 ),
//               SizedBox(width: 20),
//               GestureDetector (
//                 onTap: () {
//                   setState(() {
//                     _controller.reset();
//                     workoutNotifier.stopWorkout(context);
//                   });
//                 },
//                 child: AnimatedContainer(
//                   duration: Duration(microseconds: 1000),
//                   height: 50,
//                   width: 50,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(25),
//                     border: Border.all(color: Colors.red, width: 2),
//                   ),
//                   child: Icon(Icons.stop, color: Colors.red)))
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }