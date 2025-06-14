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

  Future<void> sendProfileData() async {
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

  String? _gender;
  String? get gender => _gender;

  int? _age;
  int? get age => _age;

  double? _height, _weight;
  double? get height => _height;
  double? get weight => _weight;

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
      gender: gender,
      // age: age ?? 0,
      height: height ?? 0,
      weight: weight ?? 0,
      foodPreference: foodPreference,
    );
  }

}

final profileDataProvider = StateNotifierProvider<ProfileDataNotifier, ProfileData>((ref) => ProfileDataNotifier());