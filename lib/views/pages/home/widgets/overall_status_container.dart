import 'package:flutter/material.dart';
import 'package:workout_tracker/models/overall_status_model.dart';
import 'package:workout_tracker/views/widgets/custom_progress_indicator.dart';

class OverallStatusContainer extends StatefulWidget {
  const OverallStatusContainer({super.key});

  @override
  State<OverallStatusContainer> createState() => _OverallStatusContainerState();
}

class _OverallStatusContainerState extends State<OverallStatusContainer> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final overallStatus = OverallStatusModel.overallStatus;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(overallStatus.length, (index) {
          final status = overallStatus[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0), // Add proper padding
            leading: Container(
              height: 30, 
              width: 30,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: overallStatus[index].containerColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: overallStatus[index].icon,
            ),
            title: Text(status.title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),),
            subtitle: Row(
              children: [
                Text(status.subtitle, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),),
                const SizedBox(width: 10),
                Text(status.gain, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.green),)
              ],
            ),
            trailing: SizedBox(
              width: 60, // Constrain the width
              child: CustomProgressIndicator(end: double.parse(status.progressPercentage.substring(0,2)) / 100),
            ),
          );
        }),
      )
    );
  }
}