import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/onboarding/screens/avatar_page.dart';
import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';
import 'package:workout_tracker/providers/profile/update_avatar_container.dart';
import 'package:workout_tracker/style/global_colors.dart';

class ProfilePictureSection extends ConsumerStatefulWidget {
  const ProfilePictureSection({super.key});

  @override
  ConsumerState<ProfilePictureSection> createState() => _ProfilePictureSectionState();
}

class _ProfilePictureSectionState extends ConsumerState<ProfilePictureSection> {
  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: UpdateAvatarContainer()
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    final profileData = ref.watch(profileDataProvider).value;
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
            radius: 100,
            backgroundImage: AssetImage(profileData?.profileImagePath ?? ''),
          )
          ],
        ),
        const SizedBox(height: 8),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: GlobalColors.primaryBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
          ),
          onPressed: () => _showImageSourceActionSheet(context),
          child: Text(
            'Change Profile Photo',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)
          ),
        ),
      ],
    );
  }
}