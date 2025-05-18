import 'package:flutter/material.dart';
import 'package:workout_tracker/style/global_colors.dart';

class DismissibleItem extends StatefulWidget {
  final String title, id;
  final String subtitle;
  final Function(DismissDirection) onDismissed;

  const DismissibleItem({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.onDismissed,
  });

  @override
  State<DismissibleItem> createState() => _DismissibleItemState();
}

class _DismissibleItemState extends State<DismissibleItem> {

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
        Future.delayed(Duration.zero, () {
          if (mounted) {  // Check if the widget is still mounted
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Workout deleted'),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    // Handle undo functionality here
                  },
                ),
              ),
            );
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: GlobalColors.boxShadow(context),
        ),        // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          title: Text(widget.title, style: theme.textTheme.bodyLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),),
          subtitle: Text(widget.subtitle, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}
