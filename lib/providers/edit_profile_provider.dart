import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workout_tracker/models/state/edit_profile_state.dart';
import 'package:workout_tracker/providers/profile_data_notifier.dart';

class EditProfileNotifier extends StateNotifier<EditProfileState> {
  Ref ref;
  EditProfileNotifier(this.ref) : super(
    EditProfileState(
      currentName: '',
      currentBio: '',
      currentLocation: '',
      currentGoal: '',
      currentFitnessLevel: '',
      currentAvatarPath: '',
    ),
  );

  TextEditingController _nameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  String? _selectedGoal;
  String? _selectedFitnessLevel;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Getters 
  TextEditingController get nameController => _nameController;
  TextEditingController get bioController => _bioController;
  TextEditingController get locationController => _locationController;
  String? get selectedGoal => _selectedGoal;
  String? get selectedFitnessLevel => _selectedFitnessLevel;
  File? get selectedImage => _selectedImage;
  ImagePicker get picker => _picker;

  void init() {
    final profile = ref.watch(profileDataProvider);
    _nameController = TextEditingController(text: profile.name);
    _bioController = TextEditingController(text: profile.bio);
    _locationController = TextEditingController(text: profile.location);
    // _selectedGoal = state.currentGoal;
    _selectedFitnessLevel = profile.fitnessLevel;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}

final editProfileProvider = StateNotifierProvider<EditProfileNotifier, EditProfileState>((ref) => EditProfileNotifier(ref));
