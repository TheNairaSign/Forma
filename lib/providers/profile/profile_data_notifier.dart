import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workout_tracker/models/enums/fitness_level.dart';
import 'package:workout_tracker/models/state/profile_data.dart';
import 'package:workout_tracker/providers/profile/update_profile_notifier.dart';
import 'package:workout_tracker/services/auth_service.dart';
import 'package:workout_tracker/services/onboarding_service.dart';

class ProfileDataNotifier extends StateNotifier<ProfileData> {
  final AuthService _authService;
  final Ref ref;
  ProfileDataNotifier(this._authService, this.ref) : super(
    ProfileData(
      name: '',
      bio: '',
      fitnessLevel: '',
      location: '',
    ),
  ) {
    loadProfileData();
  }

  Future<ProfileData?> loadProfileData() async {
    final username = await _authService.getLoggedInUser();
    debugPrint('Username: $username');
    final profile = await _authService.getProfileData();
    debugPrint('Profile drom cache: ${profile.toString()}');
    if (profile != null) {
      state = profile;
      debugPrint("User: ${profile.name}, Fitness: ${profile.fitnessLevel}, Weight: ${profile.weight}");
    } else {
      debugPrint('New user');
      state = state;
    }
    return state;
  }

  Future<bool> onBoardingCompleted() async {
    final userId = state.id;
    debugPrint('User Id completed onBoarding?: $userId');
    return await OnboardingService.instance.hasUserCompletedOnboarding(userId!);
  }

  void updateProfileId(String userId) {
    debugPrint('Upadating user id: $userId');
    state = state.copyWith(id: userId);
  }

  final TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  final TextEditingController _locationController = TextEditingController();
  TextEditingController get  locationController => _locationController;

  final TextEditingController _bioController = TextEditingController();
  TextEditingController get bioController => _bioController;

  File? _profileImage, _coverImage;

  File? get profileImage => _profileImage;
  File? get coverImage => _coverImage;

  // String? _profileImagePath, _coverImagePath;

  String _fitnessLevel = FitnessLevel.beginner.name;
  String get fitnessLevel => _fitnessLevel;

  final ImagePicker imagePicker = ImagePicker();

  void updateUserAvatar(String imagePath) {
    state = state.copyWith(profileImagePath: imagePath);
  }

  void updateFitnessLevel(String value) {
    _fitnessLevel = value;
    state = state.copyWith(fitnessLevel: value);
  }

  // Future<void> selectProfileImage() async {
  //   try {
  //     final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

  //     if (pickedFile != null) {
  //       _profileImagePath = pickedFile.path;
  //       _profileImage = File(pickedFile.path);
  //     }
  //   } catch (e) {
  //     debugPrint("Error selecting Image $e");
  //   }
  // }

  // Future<void> selectCoverImage() async {
  //   try {
  //     final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

  //     if (pickedFile != null) {
  //       _coverImagePath = pickedFile.path;
  //       _coverImage = File(pickedFile.path);
  //     }
  //   } catch (e) {
  //     debugPrint("Error selecting Image $e");
  //   }
  // }

  Future<void> sendProfileData() async {
    final username = await _authService.getLoggedInUser();
    debugPrint('Username here: $username');

    if (username != null) {
      final profile = ProfileData(
        id: state.id,
        name: username,
        gender: state.gender,
        height: state.height ?? 0,
        weight: state.weight ?? 0,
        foodPreference: foodPreference,
        profileImagePath: state.profileImagePath,
        fitnessLevel: _fitnessLevel,
        location: _locationController.text,
        currentStreak: 0,
        longestStreak: 0,
        lastWorkoutDate: null,
      );
      state = profile;

      await _authService.createProfileData(username, profile);
      debugPrint('$username profile data stored ✅ with details \n ${state.toString()}');
    }
  }

  void updateProfile(BuildContext context) {
    ref.read(updateProfleProvider(state).notifier).updateProfile(context);
    ref.listen(updateProfleProvider(state), (previous, next) {
      state = next;
    });
  }

  void updateInitialValues() {
    ref.read(updateProfleProvider(state).notifier).initialValues();
  }

  int? _age;
  int? get age => _age;

  void updateGender(String newGender) {
    state = state.copyWith(gender: newGender);
  }

  void setAge(int newAge) {
    _age = newAge;
  }

  void setHeight(double newHeight) {
    state = state.copyWith(height: newHeight);
  }

  void setWeight(double newWeight) {
    state = state.copyWith(weight: newWeight);
  }

  void setFoodPreference(List<String> newFoodPreference) {
    debugPrint('Food Preference: $newFoodPreference');
    state = state.copyWith(foodPreference: newFoodPreference);
  }

  void setBio(String? bio) {
    state = state.copyWith(bio: bio);
  }

  void setLocation(String? location) {
    state = state.copyWith(location: location);
  }

  List<String>? get foodPreference => state.foodPreference;

  String _level = Level.personal.name;
  String get level => _level; 

  void switchLevel(String newLevel) {
    _level = newLevel;
    debugPrint('New level: $newLevel');
  }

}

final profileDataProvider = StateNotifierProvider<ProfileDataNotifier, ProfileData>((ref) {
  final authService = AuthService();
  return ProfileDataNotifier(authService, ref);
});