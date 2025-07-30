import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_tracker/models/state/profile_data.dart';
import 'package:workout_tracker/providers/box_providers.dart';
import 'package:workout_tracker/services/hive_service.dart';

class AuthService {     // For auth
  static const _profileBoxName = 'newUser';  // For ProfileData
  static const _sessionKey = 'loggedIn';

  Box<ProfileData> _profileBox;

  AuthService(this._profileBox);

  /// Checks if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_sessionKey);
  }

  /// Gets the currently logged-in username
  Future<String?> getLoggedInUser() async {
    print('Getting logged in user...');
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey);
  }

  /// Logs the user out
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  /// Returns ProfileData for current user
  Future<ProfileData?> getProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_sessionKey);
    if (username == null) return null;

    print('Getting Profile data from box');

    if (!_profileBox.isOpen) {
      _profileBox = await Hive.openBox(_profileBoxName);
      await HiveService.openUserBoxes();
    }

    return _profileBox.get(username);  
  }

  /// Updates ProfileData for current user
  void updateProfileData(ProfileData newProfile) async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_sessionKey);
    if (username == null) return;

    if(!_profileBox.isOpen) {
      _profileBox = await Hive.openBox(_profileBoxName);
      await getProfileData();
      await HiveService.openUserBoxes();
    }

    await _profileBox.put(username, newProfile).then((_) async {
      print('Put profile successfully');
      await getProfileData();
      await HiveService.openUserBoxes();
    });
    print('Updated Profile data for $username with data: ${newProfile.toString()}');
  }

  /// Creates new profile data (after registration/setup)
  void createProfileData(String username, ProfileData profile) async {
    print('Creating profile data box for $username');

    if(!_profileBox.isOpen) {
      _profileBox = await Hive.openBox(_profileBoxName);
    }

    await _profileBox.put(username, profile);
    print('Created profile data box for $username');
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final profileBox = ref.watch(userProfileBoxProvider);
  return AuthService(profileBox);
});

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
