import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/constants.dart';
import 'package:workout_tracker/providers/profile_data_notifier.dart';

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
    final theme = Theme.of(context);
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  width: 3,
                ),
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
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Color(0xff1a535c),
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.scaffoldBackgroundColor, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 18,
                  color: theme.scaffoldBackgroundColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: theme.colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            )
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
            style: TextStyle(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}