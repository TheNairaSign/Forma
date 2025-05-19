import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/constants.dart';
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
    final profileData =  ref.watch(profileDataProvider.notifier);
    final profileImage = profileData.profileImage;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: profileImage != null
                    ? Image.file(
                        profileImage,
                        fit: BoxFit.cover,
                      )
                    : Image.network(placeholderProfilePic)
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: GlobalColors.primaryBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text('Choose from Gallery'),
                        onTap: () {
                          Navigator.pop(context);
                          profileData.selectProfileImage();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.camera_alt),
                        title: const Text('Take a Photo'),
                        onTap: () {
                          Navigator.pop(context);
                          // profileData.selectProfileImage();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Text(
            'Change Profile Photo',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)
          ),
        ),
      ],
    );
  }
}