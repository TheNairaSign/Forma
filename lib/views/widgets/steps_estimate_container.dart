import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';

import '../../utils/step_estimation_helper.dart';

class StepsEstimateContainer extends ConsumerStatefulWidget {
  const StepsEstimateContainer({super.key});

  @override
  ConsumerState<StepsEstimateContainer> createState() => _StepsEstimateContainerState();
}

class _StepsEstimateContainerState extends ConsumerState<StepsEstimateContainer> {
  final _helper = StepEstimationHelper();

  Widget _buildMetric(String rawFormattedValue) {
    // Split the value and unit (e.g., "123 m" => ["123", "m"])
    final parts = rawFormattedValue.split(' ');
    final value = parts[0];
    final unit = parts.length > 1 ? parts[1] : '';

    return  RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: ' $unit',
            style: GoogleFonts.notoSansMendeKikakui(
              color: Colors.grey[900],
            ),
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final steps = ref.watch(stepsProvider).steps;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard(
            icon: LucideIcons.clock,
            metric: _buildMetric(_helper.formatDurationFromSteps(steps)),
            label: 'Duration',
          ),
          _buildStatCard(
            icon: LucideIcons.mapPin,
            metric: _buildMetric(_helper.formatDistance(steps)),
            label: 'Distance',
          ),
          _buildStatCard(
            icon: LucideIcons.flame,
            metric: _buildMetric(_helper.calculateCalories(steps)),
            label: 'Calories',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Widget metric,
    required String label,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: GlobalColors.purple.withOpacity(0.1),
          child: Icon(icon, color: GlobalColors.purple, size: 20),
        ),
        const SizedBox(height: 10),
        metric,
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
