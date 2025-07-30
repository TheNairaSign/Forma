import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workout_tracker/auth/supabase/supabase_auth.dart';
import 'package:workout_tracker/models/enums/fitness_level.dart';
import 'package:workout_tracker/models/state/profile_data.dart';
import 'package:workout_tracker/providers/profile/edit_data_provider.dart';
import 'package:workout_tracker/providers/profile/update_profile_notifier.dart';
import 'package:workout_tracker/services/auth_service.dart';
import 'package:workout_tracker/services/onboarding_service.dart';

class ProfileDataNotifier extends AsyncNotifier<ProfileData> {

  @override
  Future<ProfileData> build() async {
    // Initialize the state with an empty ProfileData object
    final profile = await loadProfileData() ?? ProfileData();
    debugPrint('ProfileDataNotifier initialized with profile: ${profile.toString()}');
    state =  AsyncValue.data(profile);
    return profile;
  }


  AuthService get _authService => ref.watch(authServiceProvider);

  Future<ProfileData?> loadProfileData() async {
    final username = await _authService.getLoggedInUser();
    debugPrint('Username: $username');
    final profile = await _authService.getProfileData();
    if (profile != null) {
      debugPrint('User with $username Exists');
      debugPrint('Profile from cache: ${profile.toString()}');
      state = AsyncValue.data(profile);
      final user = await SupabaseAuth.instance.getUser();
      await SupabaseAuth.instance.getUserFromCache(user?.id);
    } else {
      debugPrint('New user');
      state = state;
    }
    return profile;
  }


  Future<bool> onBoardingCompleted() async {
    final user = await SupabaseAuth.instance.getUser();
    final userId = user?.id;
    debugPrint('User Id completed onBoarding?: $userId');
    return await OnboardingService.instance.hasUserCompletedOnboarding(userId!);
  }

  void updateProfileId(String userId) async {
    debugPrint('Updating user id: $userId');
    final current = state.value;
    if (current == null) {
      debugPrint('Current profile data is null, initializing with new user ID');
      return;
    }
    final updated = current.copyWith(id: userId);
    debugPrint('Updated profile data: ${updated.toString()}');
    state = AsyncValue.data(updated);
  }

  // final TextEditingController _nameController = TextEditingController();
  // TextEditingController get nameController => _nameController;

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

  void updateUserAvatar(String imagePath, {bool isEdit = false}) {
    final currentProfile = state.value;
    if (currentProfile == null) {
      debugPrint('Current profile data is null, cannot update avatar');
      return;
    }
    // Always update the state first
    final newAvatar = currentProfile.copyWith(profileImagePath: imagePath);

    state = AsyncValue.data(newAvatar);
    // Only persist if isEdit is true
    if (isEdit) {
      _authService.updateProfileData(newAvatar);
    }
  }

  void updateFitnessLevel(String value) {
    _fitnessLevel = value;
    debugPrint('Updated fitness level: $_fitnessLevel');
    // Always update the state first
    final currentProfile = state.value;
    if (currentProfile == null) {
      debugPrint('Current profile data is null, cannot update fitness level');
      return;
    }
    final updatedProfile = currentProfile.copyWith(fitnessLevel: value);
    debugPrint('Updated profile data: ${updatedProfile.toString()}');
    state = AsyncValue.data(updatedProfile);
    // Persist the updated profile data
    _authService.updateProfileData(updatedProfile);
  }

  Future<void> sendProfileData() async {
    final username = await _authService.getLoggedInUser();
    debugPrint('Username here: $username');

    if (username == null) {
      debugPrint('Username is null, cannot send profile data');
      return;
    }

    final currentProfile = state.value;

    if (currentProfile == null) {
      debugPrint('Current profile data is null, initializing with new user data');
      return;
    }

    final profile = ProfileData(
      id: currentProfile.id ?? 'newUser',
      name: username,
      gender: currentProfile.gender,
      height: currentProfile.height ?? 170,
      weight: currentProfile.weight ?? 70,
      foodPreference: foodPreference,
      profileImagePath: currentProfile.profileImagePath,
      fitnessLevel: _fitnessLevel,
      location: _locationController.text,
      currentStreak: 0,
      longestStreak: 0,
      lastWorkoutDate: null,
    );
    state = AsyncValue.data(profile);

    _authService.createProfileData(username, profile);
    debugPrint('$username profile data stored ✅ with details \n ${state.toString()}');
    }

  void updateProfile(BuildContext context) {
    final currentState = state.value;
    if (currentState == null) {
      debugPrint('Current profile data is null, cannot update profile');
      return;
    }
    ref.read(updateProfleProvider(currentState).notifier).updateProfile(context);
  }

  void updateInitialValues() {
    final currentState = state.value;
    if (currentState == null) {
      debugPrint('Current profile data is null, cannot update profile');
      return;
    }
    ref.read(updateProfleProvider(currentState).notifier).initialValues();
  }

  int? _age;
  int? get age => _age;

  void updateGender(BuildContext context, String newGender, {bool isEdit = false}) async {
    final currentState = state.value;

    if (currentState == null) {
      debugPrint('Current profile data is null');
      return;
    }
    // Always update the state first
    final gender = currentState.copyWith(gender: newGender);
    state = AsyncValue.data(gender);
    
    // Only persist if isEdit is true
    if (isEdit) {
      ref.read(editDataProvider(currentState).notifier).updateGender(newGender, context);
    }
  }

  void setAge(int newAge) {
    _age = newAge;
  }

  void setHeight(BuildContext context, double newHeight, {bool isEdit = false}) async {
    final currentState = state.value;

    if (currentState == null) {
      debugPrint('Current profile data is null, cannot update height');
      return;
    }
    // Always update the state first
    final height = currentState.copyWith(height: newHeight);
    state = AsyncValue.data(height);
    
    // Only persist if isEdit is true
    if (isEdit) {
      ref.read(editDataProvider(currentState).notifier).updateHeight(newHeight, context);
    }
  }

  void setWeight(BuildContext context, double newWeight, {bool isEdit = false}) async {
    final currentState = state.value;

    if (currentState == null) {
      debugPrint('Current profile data is null, cannot update weight');
      return;
    }
    // Always update the state first
    final updatedWeight = currentState.copyWith(weight: newWeight);
    state = AsyncValue.data(updatedWeight);

    // Only persist if isEdit is true
    if (isEdit) {
      ref.read(editDataProvider(currentState).notifier).updateWeight(newWeight, context);
    }
  }

  void setFoodPreference(BuildContext context, List<String> newFoodPreference, {bool isEdit = false}) async {
    debugPrint('Food Preference: $newFoodPreference');
    final currentProfile = state.value;
    if (currentProfile == null) {
      debugPrint('Current profile data is null, cannot update food preference');
      return;
    }
    final updatedProfile = currentProfile.copyWith(foodPreference: newFoodPreference);
    state = AsyncValue.data(updatedProfile);

    if (isEdit) {
      ref.read(editDataProvider(currentProfile).notifier).updateFoodPreference(newFoodPreference, context);
    }
  }

  void setBio(String? bio) {
    final currentProfile = state.value;
    if (currentProfile == null) {
      debugPrint('Current profile data is null, cannot update bio');
      return;
    }
    final updatedProfile = currentProfile.copyWith(bio: bio);
    state = AsyncValue.data(updatedProfile);
  }

  void setLocation(String? location) {
    final currentProfile = state.value;
    if (currentProfile == null) {
      debugPrint('Current profile data is null, cannot update location');
      return;
    }
    final updatedProfile = currentProfile.copyWith(location: location);
    state = AsyncValue.data(updatedProfile);
  }

  List<String>? get foodPreference => state.value?.foodPreference;

  String _level = Level.personal.name;
  String get level => _level; 

  void switchLevel(String newLevel) {
    _level = newLevel;
    debugPrint('New level: $newLevel');
  }



}

final profileDataProvider = AsyncNotifierProvider<ProfileDataNotifier, ProfileData>(() => ProfileDataNotifier());