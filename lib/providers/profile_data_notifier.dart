import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workout_tracker/models/state/profile_data.dart';
import 'package:workout_tracker/services/auth_service.dart';

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

  Future<void> loadProfileData() async {
    final username = await _authService.getLoggedInUser();
    debugPrint('Username: $username');
    final profile = await _authService.getProfileData();
    debugPrint('Profile: $profile');
    if (profile != null) {
      state = profile;
      debugPrint("User: ${profile.name}, Fitness: ${profile.fitnessLevel}, Weight: ${profile.weight}");
    } else {
      debugPrint('New user');
      state = state;
    }
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

  String? _profileImagePath, _coverImagePath;

  String? _fitnessLevel;
  String? get fitnessLevel => _fitnessLevel;

  final ImagePicker imagePicker = ImagePicker();

  void updateUserAvatar(String imagePath) {
    state = state.copyWith(profileImagePath: imagePath);
  }

  void updateFitnessLevel(String value) {
    _fitnessLevel = value;
  }

  Future<void> selectProfileImage() async {
    try {
      final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _profileImagePath = pickedFile.path;
        _profileImage = File(pickedFile.path);
      }
    } catch (e) {
      debugPrint("Error selecting Image $e");
    }
  }

  Future<void> selectCoverImage() async {
    try {
      final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _coverImagePath = pickedFile.path;
        _coverImage = File(pickedFile.path);
      }
    } catch (e) {
      debugPrint("Error selecting Image $e");
    }
  }

  Future<void> sendProfileData() async {
  final username = await _authService.getLoggedInUser();
  debugPrint('Username here: $username');

  if (username != null) {
    final profile = ProfileData(
      name: username,
      gender: state.gender,
      height: state.height ?? 0,
      weight: state.weight ?? 0,
      foodPreference: foodPreference,
      profileImagePath: state.profileImagePath,
      coverImagePath: state.coverImagePath,
      fitnessLevel: state.fitnessLevel,
      birthDate: state.birthDate,
      location: state.location,
      bio: state.bio,
      weightGoal: state.weightGoal,
      activityLevel: state.activityLevel,
      currentStreak: 0,
      longestStreak: 0,
      lastWorkoutDate: null,
    );
    state = profile;

    await _authService.createProfileData(username, profile);
    debugPrint('$username profile data stored ✅');
  }
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

  List<String>? get foodPreference => state.foodPreference;

  Future<void> sendOnboardingData() async {
    state = state.copyWith(
      gender: state.gender,
      // age: age ?? 0,
      height: state.height ?? 0,
      weight: state.weight ?? 0,
      foodPreference: foodPreference,
    );
  }

}

final profileDataProvider = StateNotifierProvider<ProfileDataNotifier, ProfileData>((ref) {
  final authService = AuthService();
  return ProfileDataNotifier(authService, ref);
});