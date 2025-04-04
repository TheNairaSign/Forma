import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/utils/format_time.dart';

class CountdownTimer extends StatelessWidget {
  final int duration;
  final CountDownController controller;
  final bool isRunning;

  const CountdownTimer({
    super.key, 
    required this.duration,
    required this.controller,
    required this.isRunning
  });

  @override
  Widget build(BuildContext context) {
    return CircularCountDownTimer(
      duration: duration,
      initialDuration: 0,
      controller: controller,
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 2,
      ringColor: Colors.grey[300]!,
      fillColor: GlobalColors.teal,
      backgroundColor: GlobalColors.primaryBlue,
      strokeWidth: 20.0,
      strokeCap: StrokeCap.round,
      textStyle: TextStyle(
        fontSize: 33.0, 
        color: Colors.white, 
        fontWeight: FontWeight.bold
      ),
      isReverse: true,
      isReverseAnimation: true,
      autoStart: false,
      timeFormatterFunction: (_, p0) {
        debugPrint('Formatter Duration: $duration');
        return formatTime(duration);
      },
    );
  }
}