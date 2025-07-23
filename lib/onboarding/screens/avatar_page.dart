// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/constants.dart';
import 'package:workout_tracker/onboarding/screens/page_view_screens/finish_up_screen.dart';
import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';
import 'package:workout_tracker/services/onboarding_service.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/views/pages/navigation/navigation_future_page.dart';

class PickAvatarPage extends ConsumerStatefulWidget {
  const PickAvatarPage({super.key, this.isEdit = false});
  final bool isEdit;

  @override
  ConsumerState<PickAvatarPage> createState() => _PickAvatarPageState();
}

class _PickAvatarPageState extends ConsumerState<PickAvatarPage> {
  // Sample avatar URLs or local asset paths
  final asset = 'assets/avatars';

  final List<String> avatars = [
    'assets/avatars/boy-avatar.png',
    'assets/avatars/girl-avatar.png',
    'assets/avatars/man-avatar.png',
    'assets/avatars/woman-avatar.png',
  ];

  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = ref.read(profileDataProvider).profileImagePath == null? null : avatars.indexWhere((element) => element == ref.read(profileDataProvider).profileImagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Choose your Avatar", style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: bodyPadding,
        child: Column(
          children: [
            // Avatars Grid
            SizedBox(
              height: 250,
              child: GridView.builder(
                  itemCount: avatars.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    final isSelected = index == selectedIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedIndex = index);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(avatars[index]),
                          ),
                          if (isSelected)...[
                            Container(
                              width: 100,
                              height: 100,
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
                  },
                ),
              ),
        
            FinishUpScreen(),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: selectedIndex == null ? null : () async {
            final selectedAvatar = avatars[selectedIndex!];
            debugPrint("Selected Avatar: $selectedAvatar");
            if(widget.isEdit) {
              ref.watch(profileDataProvider.notifier).updateUserAvatar(selectedAvatar, isEdit: true);
              Navigator.of(context).pop();
              await ref.watch(profileDataProvider.notifier).loadProfileData();
            } else {
              ref.watch(profileDataProvider.notifier).sendProfileData().then((_) {
                debugPrint("Profile Data sent successfully");
                OnboardingService.instance.setUserCompletedOnboarding(ref.watch(profileDataProvider).id!);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => NavigationFuturePage()));
              });
            }
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
    );
  }
}
