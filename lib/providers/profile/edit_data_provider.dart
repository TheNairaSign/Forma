// ignore_for_file: use_build_context_synchronously

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/models/state/profile_data.dart';
import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';
import 'package:workout_tracker/services/auth_service.dart';
import 'package:workout_tracker/utils/alerts.dart';

/// A provider that manages the edit data page state and operations
class EditDataProvider extends StateNotifier<ProfileData> {
  EditDataProvider(super.profileData, this.ref);

  final Ref ref;
  final AuthService _authService = AuthService();

  /// Loads the profile data from the profile data provider
  Future<ProfileData?> loadProfileData() async {
    final profileData = await ref.read(profileDataProvider.notifier).loadProfileData();
    return profileData;
  }

  /// Updates the height of the profile
  Future<void> updateHeight(double height, BuildContext context) async {
    if (height != state.height) {
      state = state.copyWith(height: height);
      await _authService.updateProfileData(state);
      Alerts.showFlushBar(context, 'Height updated successfully', false);
    }
  }

  /// Updates the weight of the profile
  Future<void> updateWeight(double weight, BuildContext context) async {
    if (weight != state.weight) {
      state = state.copyWith(weight: weight);
      await _authService.updateProfileData(state);
      Alerts.showFlushBar(context, 'Weight updated successfully', false);
    }
  }

  /// Updates the age of the profile
  Future<void> updateAge(int age, BuildContext context) async {
    // Age is not directly stored in ProfileData, so we need to update it through the profile data provider
    ref.read(profileDataProvider.notifier).setAge(age);
    Alerts.showFlushBar(context, 'Age updated successfully', false);
  }

  /// Updates the gender of the profile
  Future<void> updateGender(String gender, BuildContext context) async {
    if (gender != state.gender) {
      state = state.copyWith(gender: gender);
      await _authService.updateProfileData(state);
      Alerts.showFlushBar(context, 'Gender updated successfully', false);
    }
  }

  /// Updates the food preference of the profile
  Future<void> updateFoodPreference(List<String> foodPreference, BuildContext context) async {
    if (foodPreference != state.foodPreference) {
      state = state.copyWith(foodPreference: foodPreference);
      await _authService.updateProfileData(state);
      Alerts.showFlushBar(context, 'Food preference updated successfully', false);
    }
  }

  /// Syncs the state with the profile data provider
  void syncWithProfileDataProvider() {
    final profileData = ref.read(profileDataProvider);
    state = profileData;
  }
}

/// A provider that creates an instance of EditDataProvider
final editDataProvider = StateNotifierProvider.family<EditDataProvider, ProfileData, ProfileData>(
  (ref, profileData) => EditDataProvider(profileData, ref),
);