import 'package:flutter/material.dart';
import 'package:workout_tracker/views/pages/profile/widgets/profile_header.dart';
import 'package:workout_tracker/views/pages/profile/widgets/settings/settings_section.dart';
import 'package:workout_tracker/views/pages/profile/widgets/user_stats_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'My Profile',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  shadows: isDarkMode
                    ? [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.5),
                      )
                    ]
                    : null,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/grass-cover.png',
                    fit: BoxFit.cover,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
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
          ),
        ],
      ),
    );
  }
}