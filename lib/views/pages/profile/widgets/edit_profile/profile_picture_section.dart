import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/onboarding/screens/avatar_page.dart';
import 'package:workout_tracker/providers/profile_data_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';

class ProfilePictureSection extends ConsumerStatefulWidget {
  const ProfilePictureSection({super.key});

  @override
  ConsumerState<ProfilePictureSection> createState() => _ProfilePictureSectionState();
}

class _ProfilePictureSectionState extends ConsumerState<ProfilePictureSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
            radius: 100,
            backgroundImage: AssetImage(ref.watch(profileDataProvider).profileImagePath!),
          )
          ],
        ),
        const SizedBox(height: 8),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: GlobalColors.primaryBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
          ),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => PickAvatarPage(isEdit: true,))),
          child: Text(
            'Change Profile Photo',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)
          ),
        ),
      ],
    );
  }
}