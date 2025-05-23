import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class StepsProgressIndicator extends ConsumerStatefulWidget {
  const StepsProgressIndicator({super.key, this.currentSteps, this.currentCalory, required this.strokeColor, required this.measurementUnit, this.textColor, this.circularDirection = CircularDirection.clockwise, required this.targetValue});
  final int? targetValue, currentSteps, currentCalory;
  final Color strokeColor;
  final Color? textColor;
  final String measurementUnit;
  final CircularDirection? circularDirection;

  @override
  ConsumerState<StepsProgressIndicator> createState() => _StepsProgressIndicatorState();
}

class _StepsProgressIndicatorState extends ConsumerState<StepsProgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = IntTween(begin: 0, end: (widget.currentSteps ??  widget.currentCalory)).animate(_controller);
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              Center(
                child: CircularStepProgressIndicator(
                  circularDirection: widget.circularDirection!,
                  totalSteps: 100,
                  // currentValue: currentValue ~/ 100,
                  currentStep: (_animation.value / widget.targetValue!).toInt(),
                  stepSize: 10,
                  selectedColor: widget.strokeColor,
                  unselectedColor: widget.strokeColor.withOpacity(0.1),
                  padding: 0,
                  width: 100,
                  height: 100,
                  selectedStepSize: 10,
                  unselectedStepSize: 7,
                  roundedCap: (_, __) => true,
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Text(
                        (widget.currentCalory?.toString()?? widget.currentSteps.toString()),
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontSize: 22,
                          color: widget.strokeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      widget.measurementUnit,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 17,
                        color: widget.textColor,
                        fontWeight: FontWeight.bold, 
                      )
                    )
                  ],
                ), 
              )
            ],
          );
        }
      ),
    );
  }
}