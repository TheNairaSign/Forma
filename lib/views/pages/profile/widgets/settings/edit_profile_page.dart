import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/constants.dart';
import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/views/pages/profile/widgets/edit_profile/fitness_info_card.dart';
import 'package:workout_tracker/views/pages/profile/widgets/edit_profile/personal_info_card.dart';

import 'package:workout_tracker/views/pages/profile/widgets/edit_profile/profile_picture_section.dart';

class EditProfilePage extends ConsumerStatefulWidget {

  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: Theme.of(context).textTheme.headlineSmall),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => ref.watch(profileDataProvider.notifier).updateProfile(context),
            child: Text(
              'Save',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: GlobalColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: bodyPadding,
        child: ListView(
          children: [
            ProfilePictureSection(),
            const SizedBox(height: 24),
            PersonalInfoCard(),
            const SizedBox(height: 8),
            FitnessInfoCard(),
          ],
        ),
      ),
    );
  }
}