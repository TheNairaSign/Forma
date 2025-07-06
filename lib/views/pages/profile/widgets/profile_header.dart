import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileData = ref.watch(profileDataProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage(ref.watch(profileDataProvider).profileImagePath ?? ''),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text( 
                profileData.name ?? 'John Doe',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                profileData.fitnessLevel ?? 'Fitness Enthusiast',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 12,
                    color:  Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    profileData.location ?? 'San Francisco, CA',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}