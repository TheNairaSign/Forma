import 'package:flutter/material.dart';
import 'package:workout_tracker/constants.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Privacy Policy", style: theme.textTheme.headlineSmall),
        centerTitle: true,
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: bodyPadding,
        child: ListView(
          children: [
            Text(
              'Your Privacy Matters',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
          Text(
              "This Workout Tracker app respects your privacy and is committed to protecting your personal data. This policy explains what information we collect and how we use it.",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            _sectionHeader("1. Data Collection", theme),
            Text(
              "We collect minimal data needed to personalize and improve your workout experience. This includes data like name, gender, fitness level, and workout history. This data is stored securely on your device using Hive and is not shared with third parties.",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            _sectionHeader("2. Offline Use", theme),
            Text(
              "This app works completely offline. Your data is not sent to any remote servers, ensuring full control and privacy.",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            _sectionHeader("3. Sensors & Health Info", theme),
            Text(
              "If you opt-in to use device sensors like the accelerometer or step counter, this data is only used locally to help track your fitness progress and calculate calories burned. No sensor data is shared externally.",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            _sectionHeader("4. Permissions", theme),
            Text(
              "We may request permissions such as storage (for profile photos), motion (for steps tracking), and location (if enabled for certain features). These permissions are only used for their intended features.",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            _sectionHeader("5. Account & Login", theme),
            Text(
              "If you create a local account, your credentials are securely hashed and stored using industry-standard encryption methods. We never share or expose your login information.",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            _sectionHeader("6. Data Control & Deletion", theme),
            Text(
              "You can clear your workout history, profile data, or all app data at any time via settings. You have full control over your personal information.",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            _sectionHeader("7. Changes to this Policy", theme),
            Text(
              "We may update this privacy policy occasionally. Any updates will be reflected on this page.",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Text(
              "By using this app, you agree to the terms outlined in this Privacy Policy.",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            Text(
              "If you have any questions or concerns, feel free to contact the developer.",
              style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.black
      ),
    );
  }
}
