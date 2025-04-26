import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workout_tracker/models/state/profile_data.dart';

class ProfileDataNotifier extends StateNotifier<ProfileData> {
  ProfileDataNotifier() : super(
    ProfileData(
      name: '',
      bio: '',
      fitnessLevel: '',
      location: '',
    ),
  );

  final Box<ProfileData> _profileDataBox = Hive.box('profile');

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


  Future sendProfileData() async {
    final newProfile = ProfileData(
      name: _nameController.text,
      bio: _bioController.text,
      location: _locationController.text,
      profileImagePath: _profileImagePath,
      coverImagePath: _coverImagePath,
      fitnessLevel: fitnessLevel
    );
    state = newProfile;
    _profileDataBox.add(newProfile);
  }

}

final profileDataProvider = StateNotifierProvider<ProfileDataNotifier, ProfileData>((ref) => ProfileDataNotifier());