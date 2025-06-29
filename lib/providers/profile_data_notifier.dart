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
    final newProfile = ProfileData(
      name: _nameController.text,
      gender: state.gender,
      height: state.height ?? 0,
      weight: state.weight ?? 0,
      foodPreference: foodPreference,
      profileImagePath: state.profileImagePath,
    );
    state = newProfile;
    _profileDataBox.add(newProfile);
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

final profileDataProvider = StateNotifierProvider<ProfileDataNotifier, ProfileData>((ref) => ProfileDataNotifier());