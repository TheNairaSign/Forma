import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/constants.dart';
import 'package:workout_tracker/onboarding/screens/page_view_screens/age_slider_screen.dart';
import 'package:workout_tracker/onboarding/screens/page_view_screens/food_preference_screen.dart';
import 'package:workout_tracker/onboarding/screens/page_view_screens/gender_identity_screen.dart';
import 'package:workout_tracker/onboarding/screens/page_view_screens/height_slider_screen.dart.dart';
import 'package:workout_tracker/onboarding/screens/page_view_screens/weight_slider_screen.dart';
import 'package:workout_tracker/providers/calories_provider.dart';
import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/utils/extensions/capitalize.dart';
import 'package:workout_tracker/views/widgets/custom_text_field.dart';

class EditDataPage extends ConsumerWidget {
  const EditDataPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileDataProvider);
    final age = ref.watch(profileDataProvider.notifier).age ?? 25;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: profileAsync.when(
        data: (profile) {
          final foodPreferences = profile.foodPreference?.map((food) => food.capitalize()).toList();
          return Padding(
            padding: bodyPadding,
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoCard(
                      title: 'Height',
                      value: '${profile.height}m',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => HeightSliderScreen(isEdit: true),
                        ),
                      ),
                    ),
                    InfoCard(
                      title: 'Weight',
                      value: '${(profile.weight)?.toStringAsFixed(2)}kg',
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
                    InfoCard(
                      title: 'Age',
                      value: '${age}yrs',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const AgeSliderScreen(isEdit: true),
                        ),
                      ),
                    ),
                    InfoCard(
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
                InfoCard(
                  title: 'Food Preference',
                  value: foodPreferences?.join(', ') ?? 'Not set',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const FoodPreferenceScreen(isEdit: true),
                    ),
                  ),
                  isExpanded: true,
                ),
                Row(
                  children: [
                    StepTargetField(),
                    const SizedBox(width: 10),
                    CalorieTargetField()
                  ],
                  )
                ],
              ),
            );
          },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      )
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;
  final bool isExpanded;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
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

class SaveButton extends StatelessWidget {
  const SaveButton({super.key, required this.onSave});
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onSave,
      child: Container(
        padding: EdgeInsets.all(5),
        height: 25,
        width: 40,
        decoration: BoxDecoration(
          color: Color(0xff2b2d30),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Text('Save', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey), textAlign: TextAlign.center,),
      ),
    );
  }
}


class StepTargetField extends ConsumerStatefulWidget {
  const StepTargetField({super.key});

  @override
  ConsumerState<StepTargetField> createState() => _StepTargetFieldState();
}

class _StepTargetFieldState extends ConsumerState<StepTargetField> {
  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    final steps = ref.watch(stepsProvider.notifier);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Target Steps', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 5),
              CustomTextField(
                enableBorder: false,
                controller: steps.targetStepsController,
                hintText: 'Target Steps',
                keyboardType: TextInputType.number,
                suffix: isEdit ? SaveButton(onSave: () => steps.updateTargetSteps(context)) : null,
                onChanged: (value) {
                  setState(() {
                    if (value != steps.dailyTargetSteps.toString()) {
                      isEdit = true;
                    } else {
                      isEdit = false;
                    }
                  });
                  debugPrint('Target Steps changed: $value');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalorieTargetField extends ConsumerStatefulWidget {
  const CalorieTargetField({super.key});

  @override
  ConsumerState<CalorieTargetField> createState() => _CalorieTargetFieldState();
}

class _CalorieTargetFieldState extends ConsumerState<CalorieTargetField> {
  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    final calories = ref.watch(caloriesProvider.notifier);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Target Calories', style: Theme.of(context).textTheme.bodyMedium?.copyWith()),
              const SizedBox(height: 5),
              CustomTextField(
                enableBorder: false,
                controller: calories.targetCaloriesController,
                hintText: 'Target Calories',
                keyboardType: TextInputType.number,
                suffix: isEdit ? SaveButton(onSave: () => calories.updateTargetCalories(context)) : null,
                onChanged: (value) {
                  setState(() {
                    if (value != calories.targetCalories.toString()) {
                      isEdit = true;
                    } else {
                      isEdit = false;
                    }
                  });
                  debugPrint('Target Calories changed: $value');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


