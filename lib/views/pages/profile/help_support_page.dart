import 'package:flutter/material.dart';
import 'package:workout_tracker/constants.dart';
import 'package:workout_tracker/style/global_colors.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Help & Support", style: Theme.of(context).textTheme.headlineSmall),
        centerTitle: true,
      ),
      body: Padding(
        padding: bodyPadding,
        child: ListView(
          children: [
            Text(
              'Need Help?',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "We're here to support you. Below are common questions and how to get assistance.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            _sectionHeader("FAQs", theme),
            const SizedBox(height: 10),
            _faqTile(
              question: "How do I track my workouts?",
              answer: "Go to the Add Workout screen and select the type of workout. Fill out the form and save it.",
            ),
            _faqTile(
              question: "How are calories calculated?",
              answer: "Calories are estimated using MET values, your weight, and workout duration or effort.",
            ),
            _faqTile(
              question: "Can I use this app offline?",
              answer: "Yes! This app works completely offline. All data is stored locally on your device.",
            ),
            _faqTile(
              question: "How do I reset my data?",
              answer: "Navigate to Settings > Clear My Data to reset workouts, calories, and profile info.",
            ),
            const SizedBox(height: 14),
            _sectionHeader("Contact Support", theme),
            const SizedBox(height: 10),
            const Text("If you're still having issues or need more help, contact us via:"),
            const SizedBox(height: 10),
            const SelectableText("📧 Email: support@fittrackapp.com"),
            const SelectableText("💬 WhatsApp: +234 123 456 7890"),
            const SizedBox(height: 24),
            _sectionHeader("Feedback & Suggestions", theme),
            const SizedBox(height: 10),
            const Text("We love feedback! Use the contact details above to share suggestions or report bugs."),
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
      ),
    );
  }

  Widget _faqTile({required String question, required String answer}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        iconColor: Colors.black,
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide.none,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide.none,
        ),
        backgroundColor: GlobalColors.primaryColorLight,
        collapsedBackgroundColor: Colors.white,
        title: Text(question, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.vertical()
            ),
            padding: const EdgeInsets.all(16.0),
            child: Text(answer, style: Theme.of(context).textTheme.bodyMedium,),
          )
        ],
      ),
    );
  }
}
