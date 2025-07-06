import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workout_tracker/models/enums/fitness_level.dart';
import 'package:workout_tracker/models/state/profile_data.dart';
import 'package:workout_tracker/providers/profile/update_profile_notifier.dart';
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

  // String? _profileImagePath, _coverImagePath;

  String? _fitnessLevel;
  String? get fitnessLevel => _fitnessLevel;

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
        name: username,
        gender: state.gender,
        height: state.height ?? 0,
        weight: state.weight ?? 0,
        foodPreference: foodPreference,
        profileImagePath: state.profileImagePath,
        coverImagePath: state.coverImagePath,
        fitnessLevel: _fitnessLevel,
        birthDate: state.birthDate,
        location: _locationController.text,
        bio: state.bio,
        weightGoal: state.weightGoal,
        activityLevel: state.activityLevel,
        currentStreak: 0,
        longestStreak: 0,
        lastWorkoutDate: null,
      );
      state = profile;

      debugPrint('Profile State Data:');
      debugPrint('Name: ${profile.name}');
      debugPrint('Gender: ${profile.gender}');
      debugPrint('Height: ${profile.height}');
      debugPrint('Weight: ${profile.weight}');
      debugPrint('Food Preference: ${profile.foodPreference}');
      debugPrint('Profile Image: ${profile.profileImagePath}');
      debugPrint('Cover Image: ${profile.coverImagePath}');
      debugPrint('Fitness Level: ${profile.fitnessLevel}');
      debugPrint('Birth Date: ${profile.birthDate}');
      debugPrint('Location: ${profile.location}');
      debugPrint('Bio: ${profile.bio}');
      debugPrint('Weight Goal: ${profile.weightGoal}');
      debugPrint('Activity Level: ${profile.activityLevel}');
      debugPrint('Current Streak: ${profile.currentStreak}');
      debugPrint('Longest Streak: ${profile.longestStreak}');
      debugPrint('Last Workout: ${profile.lastWorkoutDate}');

      await _authService.createProfileData(username, profile);
      debugPrint('$username profile data stored ✅');
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