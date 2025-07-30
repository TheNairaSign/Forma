import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/models/enums/fitness_level.dart';
import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';
import 'package:workout_tracker/utils/extensions/capitalize.dart';
import 'package:workout_tracker/views/widgets/custom_drop_down_button.dart';
import 'package:workout_tracker/views/widgets/custom_text_field.dart';

class FinishUpScreen extends ConsumerStatefulWidget {
  const FinishUpScreen({super.key});

  @override
  ConsumerState<FinishUpScreen> createState() => _FinishUpScreen();
}

class _FinishUpScreen extends ConsumerState<FinishUpScreen> {
  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileDataProvider.notifier);
    final width = MediaQuery.of(context).size.width * 0.4;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Let\'s finish up',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 26),
        ),
        const SizedBox(height: 10),
        CustomTextField(
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          controller: profile.locationController, 
          hintText: 'Address'
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: width,
              child: CustomDropdownButton(
                items: Level.values.map((value) => value.name.capitalize()).toList(),
                hint: profile.level[0].toUpperCase() + profile.level.substring(1),
                textColor: Colors.black,
                onChanged: (p0) {
                  debugPrint('Switched level: $p0');
                  profile.switchLevel(p0!);
                  setState(() {});
                }, 
              ),
            ),
            SizedBox(
              width: width,
              child: CustomDropdownButton(
                items: profile.level == Level.personal.name.capitalize()
                    ? FitnessLevel.values.map((value) => value.label).toList()
                    : FitnessRole.values.map((value) => value.label).toList(),
                hint: profile.level == Level.personal.name  
                    ? 'Fitness level' 
                    : 'Fitness Role',
                textColor: Colors.black,
                onChanged: (fitnessLevel) {
                  profile.updateFitnessLevel(fitnessLevel!);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}