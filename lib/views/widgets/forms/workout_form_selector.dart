import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Consumer;
import 'package:workout_tracker/models/enums/workout_group.dart';
import 'package:workout_tracker/models/enums/workout_type.dart';
import 'package:workout_tracker/providers/workout_group_notifier.dart';
import 'package:provider/provider.dart';

class WorkoutFormSelector extends ConsumerStatefulWidget {
  final WorkoutType selectedWorkoutType;

  const WorkoutFormSelector({
    super.key,
    required this.selectedWorkoutType,
  });

  @override
  ConsumerState<WorkoutFormSelector> createState() => _WorkoutFormSelectorState();
}

class _WorkoutFormSelectorState extends ConsumerState<WorkoutFormSelector> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(WorkoutFormSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedWorkoutType != widget.selectedWorkoutType) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workoutGroup = workoutGroupMap[widget.selectedWorkoutType]!;
    
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(_animation),
        child: Consumer<WorkoutGroupNotifier>(
          builder: (context, notifier, _) {
            return notifier.buildForm(context, ref);
          },
        ),
      ),
    );
  }
}