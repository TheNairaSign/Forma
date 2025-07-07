import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/constants.dart';

import 'package:workout_tracker/onboarding/screens/page_view_screens/age_slider_screen.dart';
import 'package:workout_tracker/onboarding/screens/page_view_screens/food_preference_screen.dart';
import 'package:workout_tracker/onboarding/screens/page_view_screens/gender_identity_screen.dart';
import 'package:workout_tracker/onboarding/screens/page_view_screens/height_slider_screen.dart.dart';
import 'package:workout_tracker/onboarding/screens/page_view_screens/weight_slider_screen.dart';
import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';

class EditDataPage extends ConsumerWidget {
  const EditDataPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: const _EditDataBody(),
    );
  }
}

class _EditDataBody extends ConsumerWidget {
  const _EditDataBody();
    @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileDataProvider);
    final age = ref.watch(profileDataProvider.notifier).age ?? 25;

    return Padding(
      padding: bodyPadding,
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(
                context,
                title: 'Height',
                value: '${profile.height}m',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const HeightSliderScreen(isEdit: true),
                  ),
                ),
              ),
              _buildInfoCard(
                context,
                title: 'Weight',
                value: '${profile.weight}kg',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const WeightSliderScreen(isEdit: true),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(
                context,
                title: 'Age',
                value: '${age}yrs',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const AgeSliderScreen(isEdit: true),
                  ),
                ),
              ),
              _buildInfoCard(
                context,
                title: 'Gender',
                value: profile.gender != null
                    ? profile.gender![0].toUpperCase() +
                        profile.gender!.substring(1)
                    : '',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const GenderIdentityScreen(isEdit: true),
                  ),
                ),
              ),
            ],
          ),
          _buildInfoCard(
            context,
            title: 'Food Preference',
            value: '${profile.foodPreference}',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => const FoodPreferenceScreen(isEdit: true),
              ),
            ),
            isExpanded: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    {
    required String title,
    required String value,
    required VoidCallback onTap,
    bool isExpanded = false,
  }) {
    final card = Accordion(
      maxOpenSections: 1,
      headerPadding: const EdgeInsets.all(10),
      headerBackgroundColor: Colors.white,
      headerBackgroundColorOpened: GlobalColors.primaryColorLight,
      headerBorderColorOpened: GlobalColors.primaryColorLight,
      contentBorderColor: GlobalColors.primaryColorLight,
      children: [
        AccordionSection(
          isOpen: true,
          headerBorderColorOpened: Colors.blue,
          header: Text(title, style: Theme.of(context).textTheme.bodyMedium),
          content: GestureDetector(
            onTap: onTap,
            child: Text('Edit: $value', style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
      ],
    );

    return isExpanded ? card : Expanded(child: card);
  }
}