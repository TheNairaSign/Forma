import 'package:flutter/material.dart';
import 'package:workout_tracker/constants.dart';
import 'package:workout_tracker/views/pages/profile/widgets/profile_header.dart';
import 'package:workout_tracker/views/pages/profile/widgets/settings/settings_section.dart';
import 'package:workout_tracker/views/pages/profile/widgets/user_stats_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(actions: [
        Text('Logout', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.red, fontWeight: FontWeight.bold),),
        const SizedBox(width: 6),
        Icon(Icons.logout, color:Colors.red, size: 17,),
        const SizedBox(width: 16),
        
      ],),
      body: Padding(
        padding: bodyPadding,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            ProfileHeader(),
            const SizedBox(height: 24),
            UserStats(),
            const SizedBox(height: 24),
            // AchievementSection(),
            // const SizedBox(height: 24),
            SettingsSection(),
          ],
        ),
      ),
    );
  }
}