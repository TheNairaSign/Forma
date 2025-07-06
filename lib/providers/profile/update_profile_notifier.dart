// ignore_for_file: use_build_context_synchronously

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/models/state/profile_data.dart';
import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';
import 'package:workout_tracker/services/auth_service.dart';
import 'package:workout_tracker/utils/alerts.dart';

class UpdateProfileNotifier extends StateNotifier<ProfileData> {
  UpdateProfileNotifier(super.profileData, this.ref, this._authService);

  final Ref ref;
  final AuthService _authService;

  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();

  TextEditingController get nameController => _nameController;
  TextEditingController get bioController => _bioController;
  TextEditingController get locationController => _locationController;

  void initialValues() {
    _nameController.text = state.name ?? '';
    _bioController.text = state.bio ?? '';
    _locationController.text = state.location ?? '';
  }

  void resetValues() {
    _nameController.text = '';
    _bioController.text = '';
    _locationController.text = '';
  }

  void updateProfile(BuildContext context) async {
    final name = _nameController.text;
    final bio = _bioController.text;
    final location = _locationController.text;

    if (name.isNotEmpty || bio.isNotEmpty || location.isNotEmpty) {
      if (name != state.name || bio != state.bio || location != state.location) {
        state = state.copyWith(
          name: name,
          bio: bio,
          location: location,
        );

        await _authService.updateProfileData(state);

        ref.watch(profileDataProvider.notifier).loadProfileData();

        Alerts.showFlushBar(context, 'Data updated successfully', false);
      }
    }
  }
}

final updateProfleProvider = StateNotifierProvider.family<UpdateProfileNotifier, ProfileData, ProfileData>((ref, profileData) {
  final authService = AuthService();
  return UpdateProfileNotifier(profileData, ref, authService);
});