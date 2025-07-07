// // lib/screens/progress_screen.dart

// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:workout_tracker/models/workout/workout.dart';
// import 'package:workout_tracker/models/workout/workout_session.dart';

// class ProgressScreen extends StatefulWidget {
//   final List<Workout> workouts;

//   const ProgressScreen({super.key, required this.workouts});

//   @override
//   State<ProgressScreen> createState() => _ProgressScreenState();
// }

// class _ProgressScreenState extends State<ProgressScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String _filter = 'Week';
//   Workout? _selectedWorkout;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _selectedWorkout = widget.workouts.isNotEmpty ? widget.workouts[0] : null;
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   List<FlSpot> _getDurationSpots({Workout? workout}) {
//     final now = DateTime.now();
//     final days = _filter == 'Week' ? 7 : 30;
//     final startDate = now.subtract(Duration(days: days - 1));
//     final dailyTotals = List.filled(days, 0.0);

//     final targetWorkouts = workout != null ? [workout] : widget.workouts;
//     for (var w in targetWorkouts) {
//       for (var session in w.sessions) {
//         if (session.timestamp.isAfter(startDate)) {
//           final dayIndex = session.timestamp.difference(startDate).inDays;
//           if (dayIndex >= 0 && dayIndex < days) {
//             dailyTotals[dayIndex] += session.durationInSeconds / 60;
//           }
//         }
//       }
//     }

//     return List.generate(days, (index) => FlSpot(index.toDouble(), dailyTotals[index]));
//   }

//   WorkoutSession? _getBestSession() {
//     WorkoutSession? best;
//     for (var workout in widget.workouts) {
//       for (var session in workout.sessions) {
//         if (best == null || session.durationInSeconds > best.durationInSeconds) best = session;
//       }
//     }
//     return best;
//   }

//   int _getWorkoutFrequency() {
//     final now = DateTime.now();
//     final weekAgo = now.subtract(Duration(days: 7));
//     return widget.workouts.fold(0, (sum, w) => sum + w.sessions.where((s) => s.timestamp.isAfter(weekAgo)).length);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final totalWorkouts = widget.workouts.length;
//     final totalDuration = widget.workouts.fold(0, (sum, w) => sum + w.durationInSeconds);
//     final totalSets = widget.workouts.fold(0, (sum, w) => sum + w.sessions.fold(0, (s, sess) => s + sess.setsCompleted));
//     final totalReps = widget.workouts.fold(0, (sum, w) => sum + w.sessions.fold(0, (s, sess) => s + sess.repsCompleted));
//     final avgDuration = totalWorkouts > 0 ? totalDuration / totalWorkouts / 60 : 0;
//     final bestSession = _getBestSession();
//     final frequency = _getWorkoutFrequency();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Progress'),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: [Tab(text: 'Overall'), Tab(text: 'Per Workout')],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           SingleChildScrollView(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Overall Stats', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)).animate().fadeIn(duration: 500.ms),
//                 SizedBox(height: 10),
//                 Card(
//                   elevation: 4,
//                   child: Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Total Workouts: $totalWorkouts'),
//                         Text('Total Time: ${_formatTime(totalDuration)}'),
//                         Text('Total Sets: $totalSets'),
//                         Text('Total Reps: $totalReps'),
//                         Text('Avg. Session: ${avgDuration.toStringAsFixed(1)} min'),
//                         Text('Best Session: ${bestSession != null ? _formatTime(bestSession.durationInSeconds) : 'N/A'}'),
//                         Text('Weekly Frequency: $frequency sessions'),
//                       ],
//                     ),
//                   ),
//                 ).animate().slideY(begin: 0.2, end: 0, duration: 500.ms),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Duration ($_filter)', style: TextStyle(fontSize: 16)),
//                     DropdownButton<String>(
//                       value: _filter,
//                       items: ['Week', 'Month'].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
//                       onChanged: (value) => setState(() => _filter = value!),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 SizedBox(
//                   height: 250,
//                   child: LineChart(
//                     LineChartData(
//                       gridData: FlGridData(drawHorizontalLine: true),
//                       titlesData: FlTitlesData(
//                         bottomTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             getTitlesWidget: (value, meta) => Text(_filter == 'Week' ? ['M', 'T', 'W', 'T', 'F', 'S', 'S'][value.toInt()] : value % 5 == 0 ? value.toInt().toString() : ''),
//                           ),
//                         ),
//                         leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
//                       ),
//                       borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey)),
//                       lineBarsData: [
//                         LineChartBarData(
//                           spots: _getDurationSpots(),
//                           isCurved: true,
//                           color: Colors.blueAccent,
//                           dotData: FlDotData(show: true),
//                           belowBarData: BarAreaData(show: true, color: Colors.blueAccent.withOpacity(0.2)),
//                         ),
//                       ],
//                       minY: 0,
//                     ),
//                   ),
//                 ).animate().fadeIn(duration: 700.ms),
//               ],
//             ),
//           ),
//           SingleChildScrollView(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Per Workout Progress', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)).animate().fadeIn(duration: 500.ms),
//                 SizedBox(height: 10),
//                 if (widget.workouts.isNotEmpty) ...[
//                   DropdownButton<Workout>(
//                     value: _selectedWorkout,
//                     items: widget.workouts.map((w) => DropdownMenuItem(value: w, child: Text(w.name))).toList(),
//                     onChanged: (value) => setState(() => _selectedWorkout = value),
//                   ),
//                   SizedBox(height: 10),
//                   if (_selectedWorkout != null) ...[
//                     Card(
//                       elevation: 4,
//                       child: Padding(
//                         padding: EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Sessions: ${_selectedWorkout!.sessions.length}'),
//                             Text('Total Time: ${_formatTime(_selectedWorkout!.durationInSeconds)}'),
//                             Text('Total Sets: ${_selectedWorkout!.sessions.fold(0, (s, sess) => s + sess.setsCompleted)}'),
//                             Text('Total Reps: ${_selectedWorkout!.sessions.fold(0, (s, sess) => s + sess.repsCompleted)}'),
//                             if (_selectedWorkout!.goalReps != null)
//                               Text('Reps Goal: ${_selectedWorkout!.sessions.fold(0, (s, sess) => s + sess.repsCompleted)} / ${_selectedWorkout!.goalReps} (${(_selectedWorkout!.sessions.fold(0, (s, sess) => s + sess.repsCompleted) / _selectedWorkout!.goalReps! * 100).toStringAsFixed(1)}%)'),
//                             if (_selectedWorkout!.goalDuration != null)
//                               Text('Duration Goal: ${_formatTime(_selectedWorkout!.durationInSeconds)} / ${_formatTime(_selectedWorkout!.goalDuration!)} (${(_selectedWorkout!.durationInSeconds / _selectedWorkout!.goalDuration! * 100).toStringAsFixed(1)}%)'),
//                           ],
//                         ),
//                       ),
//                     ).animate().slideY(begin: 0.2, end: 0, duration: 500.ms),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Duration ($_filter)', style: TextStyle(fontSize: 16)),
//                         DropdownButton<String>(
//                           value: _filter,
//                           items: ['Week', 'Month'].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
//                           onChanged: (value) => setState(() => _filter = value!),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//                     SizedBox(
//                       height: 250,
//                       child: LineChart(
//                         LineChartData(
//                           gridData: FlGridData(drawHorizontalLine: true),
//                           titlesData: FlTitlesData(
//                             bottomTitles: AxisTitles(
//                               sideTitles: SideTitles(
//                                 showTitles: true,
//                                 getTitlesWidget: (value, meta) => Text(_filter == 'Week' ? ['M', 'T', 'W', 'T', 'F', 'S', 'S'][value.toInt()] : value % 5 == 0 ? value.toInt().toString() : ''),
//                               ),
//                             ),
//                             leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
//                           ),
//                           borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey)),
//                           lineBarsData: [
//                             LineChartBarData(
//                               spots: _getDurationSpots(workout: _selectedWorkout),
//                               isCurved: true,
//                               color: Colors.green,
//                               dotData: FlDotData(show: true),
//                               belowBarData: BarAreaData(show: true, color: Colors.green.withOpacity(0.2)),
//                             ),
//                           ],
//                           minY: 0,
//                         ),
//                       ),
//                     ).animate().fadeIn(duration: 700.ms),
//                   ],
//                 ] else
//                   Text('No workouts yet.'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatTime(int seconds) {
//     final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
//     final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
//     final secs = (seconds % 60).toString().padLeft(2, '0');
//     return '$hours:$minutes:$secs';
//   }
// }