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
  AuthService get _authService => ref.watch(authServiceProvider);

  /// Loads the profile data from the profile data provider
  Future<ProfileData?> loadProfileData() async {
    final profileData = await ref.read(profileDataProvider.notifier).loadProfileData();
    return profileData;
  }

  /// Updates the height of the profile
  void updateHeight(double height, BuildContext context) {
    if (height != state.height) {
      state = state.copyWith(height: height);
      _authService.updateProfileData(state);
      Alerts.showFlushBar(context, 'Height updated successfully', false);
    }
  }

  /// Updates the weight of the profile
  void updateWeight(double weight, BuildContext context) {
    if (weight != state.weight) {
      state = state.copyWith(weight: weight);
      _authService.updateProfileData(state);
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
  void updateGender(String gender, BuildContext context) {
    if (gender != state.gender) {
      final newData = state.copyWith(gender: gender);
      _authService.updateProfileData(newData);
      state = newData;
      Alerts.showFlushBar(context, 'Gender updated successfully', false);
    }
  }

  /// Updates the food preference of the profile
  void updateFoodPreference(List<String> foodPreference, BuildContext context) {
    if (foodPreference != state.foodPreference) {
      state = state.copyWith(foodPreference: foodPreference);
      _authService.updateProfileData(state);
      // Alerts.showFlushBar(context, 'Food preference updated successfully', false);
    }
  }

  /// Syncs the state with the profile data provider
  // void syncWithProfileDataProvider() {
  //   final profileData = ref.read(profileDataProvider);
  //   state = profileData;
  // }
}

/// A provider that creates an instance of EditDataProvider
final editDataProvider = StateNotifierProvider.family<EditDataProvider, ProfileData, ProfileData>(
  (ref, profileData) => EditDataProvider(profileData, ref),
);