import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/models/workout/workout.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';

class DismissibleItem extends ConsumerStatefulWidget {
  final String title, id;
  final String subtitle;
  final Function(DismissDirection) onDismissed;
  final Workout workout;

  const DismissibleItem({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.onDismissed,
    required this.workout,
  });

  @override
  ConsumerState<DismissibleItem> createState() => _DismissibleItemState();
}

class _DismissibleItemState extends ConsumerState<DismissibleItem> {

  @override
  Widget build(BuildContext context) {
  final theme = Theme.of(context);

    return Dismissible(
      key: Key(widget.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.delete, color: Colors.white, size: 25),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text('Are you sure you want to delete this workout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel', style: Theme.of(context).textTheme.bodyMedium,),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Delete', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        widget.onDismissed(direction);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Workout deleted'),
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'UNDO',
                textColor: GlobalColors.primaryBlue,
                onPressed: () => ref.watch(workoutItemProvider.notifier).undoDelete(context, widget.id),
              ),
            ),
          );
        }
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: GlobalColors.boxShadow(context),
        ),
        child: ListTile(
          leading: Container(
            height: 10, 
            width: 10,
            decoration: BoxDecoration(
              color: widget.workout.workoutColor ??  GlobalColors.purple,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          title: Text(widget.title, style: theme.textTheme.bodyLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),),
          subtitle: Text(widget.subtitle, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black)),
        ),
      ),
    );
  }
}
