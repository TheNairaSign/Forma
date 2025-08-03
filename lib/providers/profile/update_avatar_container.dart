import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/onboarding/screens/avatar_page.dart';
import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';

import '../../utils/flush/flushbar_service.dart';

class UpdateAvatarContainer extends ConsumerStatefulWidget {
  const UpdateAvatarContainer({super.key});

  @override
  ConsumerState<UpdateAvatarContainer> createState() => _UpdateAvatarContainerState();
}

class _UpdateAvatarContainerState extends ConsumerState<UpdateAvatarContainer> {
  int? selectedIndex;


  @override
  void initState() {
    super.initState();
    initializeSelectedIndex();
  }

  void initializeSelectedIndex() {
    final profileData = ref.read(profileDataProvider).value;
    if (profileData == null) {
      selectedIndex = null;
      return;
    }
    final profileImagePath = profileData.profileImagePath;
    if (profileImagePath == null) {
      selectedIndex = null;
      return;
    }
    selectedIndex = avatars.indexWhere((element) => element == profileImagePath);
    if (selectedIndex == -1) {
      selectedIndex = null;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Choose your Avatar",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey[900]),
            textAlign: TextAlign.center,
          ),
        ),
        Wrap(
          spacing: 10,
          children: List.generate(avatars.length, (index) {
            final isSelected = index == selectedIndex;
            return GestureDetector(
              onTap: () {
                setState(() => selectedIndex = index);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(avatars[index]),
                  ),
                  if (isSelected)...[
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: GlobalColors.primaryColor, width: 4),
                      ),
                    ),
                    const Icon(
                      Icons.check_circle,
                      color: GlobalColors.primaryColor,
                      size: 30,
                    ),
                  ]
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: selectedIndex == null ? null : () async {
              final selectedAvatar = avatars[selectedIndex!];
              debugPrint("Selected Avatar: $selectedAvatar");
                debugPrint('Avatar is Edit');
                ref.watch(profileDataProvider.notifier).updateUserAvatar(selectedAvatar, isEdit: true);
                Navigator.of(context).pop();
                FlushbarService.show(context, message: 'Avatar updated successfully');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: GlobalColors.primaryColor,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text("Continue", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18, color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
