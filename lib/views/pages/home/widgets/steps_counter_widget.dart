import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';

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
    
    return Container(
      height: 400,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 240,
            height: 240,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
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
          
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Calories burned
              Container(
                width: 140,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cal Burned',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ref.watch(stepsProvider.notifier).getStepsCalory().toString(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Daily goal
              Container(
                width: 140,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Daily Goal',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ref.watch(stepsProvider.notifier).dailyTargetSteps.toString(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}