import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/views/pages/activity/widgets/stat_card.dart';

class StepCounterWidget extends ConsumerStatefulWidget {
  final int caloriesBurned;
  final Color progressColor;

  const StepCounterWidget({
    super.key,
    required this.caloriesBurned,
    required this.progressColor,
  });

  @override
  ConsumerState<StepCounterWidget> createState() => _StepCounterWidgetState();
}

class _StepCounterWidgetState extends ConsumerState<StepCounterWidget> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<int> _animation;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = IntTween(begin: 0, end:  ref.read(stepsProvider).steps).animate(_controller);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        Row(
          children: [
            StatsCard(
              title: 'Target Steps',
              value: ref.watch(stepsProvider.notifier).dailyTargetSteps.toString(),
              icon: Icons.local_fire_department,
            ),
            const SizedBox(width: 12),
            StatsCard(
              title: 'Calories burned',
              value: ref.watch(stepsProvider.notifier).getStepsCalory().toString(),
              icon: Icons.timeline,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: GlobalColors.boxShadow(context)
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(text: TextSpan(
                children: [
                  TextSpan(
                    text: 'You have walked',
                    style: Theme.of(context).textTheme.headlineSmall
                  ),
                  TextSpan(
                    text: ' ${ref.watch(stepsProvider).steps}\nsteps',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Color(0xff6f64df))
                  ),
                  TextSpan(
                    text: ' today',
                    style: Theme.of(context).textTheme.headlineSmall
                  ),
                ]
              )),
              const SizedBox(height: 20),
              SizedBox(
                width: 180,
                height: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background circle
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                    ),
                    
                    // Progress indicator
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return CircularProgressIndicator(
                            value: ref.watch(stepsProvider.notifier).stepsProgress(_animation.value),
                            strokeWidth: 10,
                            strokeCap: StrokeCap.round,
                            backgroundColor: Colors.grey.shade100,
                            valueColor: AlwaysStoppedAnimation<Color>(widget.progressColor),
                          );
                        }
                      ),
                    ),
                    
                    // Steps counter display
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Footsteps icon
                        Icon(Icons.directions_walk, color: widget.progressColor, size: 32),
                        
                        const SizedBox(height: 8),
                        
                        // Steps count
                        Text(
                          ref.watch(stepsProvider).steps.toString(),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: widget.progressColor,
                          ),
                        ),
                        
                        // Steps label
                        Text(
                          'Steps',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }
}