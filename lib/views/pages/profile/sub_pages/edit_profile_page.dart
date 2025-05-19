import 'package:flutter/material.dart';
import 'package:workout_tracker/constants.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/views/pages/profile/widgets/edit_profile/fitness_info_card.dart';
import 'package:workout_tracker/views/pages/profile/widgets/edit_profile/personal_info_card.dart';

import 'package:workout_tracker/views/pages/profile/widgets/edit_profile/profile_picture_section.dart';

class EditProfilePage extends StatefulWidget {

  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: Theme.of(context).textTheme.headlineSmall),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
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