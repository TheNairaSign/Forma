import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_tracker/models/state/profile_data.dart';

class AuthService {     // For auth
  static const _profileBoxName = 'newUser';  // For ProfileData
  static const _sessionKey = 'loggedIn';

  final Box<ProfileData> profileBox = Hive.box<ProfileData>(_profileBoxName);

  /// Hashes the password using SHA-256
  // Box<ProfileData> get userBox => Hive.box<ProfileData>(_userBoxName);

  /// Hashes the password using SHA-256
  // String _hashPassword(String password) {
  //   final bytes = utf8.encode(password);
  //   return sha256.convert(bytes).toString();
  // }

  /// Registers a new user (username + password)
  // Future<void> register(String username, String email, String password) async {
  //   final box = await Hive.openBox(_userBoxName);

  //   if (box.containsKey(username)) {
  //     throw AuthException('User already exists');
  //   }

  //   final hashedPassword = _hashPassword(password);

  //   await box.put(username, {
  //     'email': email,
  //     'password': hashedPassword,
  //     'createdAt': DateTime.now().toIso8601String(),
  //   });
  // }

  /// Logs in the user
  // Future<void> login(String email, String password) async {
  //   final box = await Hive.openBox(_userBoxName);

  //   // Find user by email
  //   String? username;
  //   dynamic userValue;
  //   for (final key in box.keys) {
  //     final value = box.get(key);
  //     if (value is Map && value['email'] == email) {
  //       username = key as String;
  //       userValue = value;
  //       break;
  //     }
  //   }

  //   if (userValue == null) throw AuthException('User not found');

  //   final hashedInput = _hashPassword(password);
  //   if (userValue['password'] != hashedInput) {
  //     throw AuthException('Invalid credentials');
  //   }

  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(_sessionKey, username!);
  // }

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

    // final profileBox = await Hive.openBox<ProfileData>(_profileBoxName);
    print('Getting Profile data from box');
    return profileBox.get(username);  
  }

  /// Updates ProfileData for current user
  Future<void> updateProfileData(ProfileData newProfile) async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_sessionKey);
    if (username == null) return;

    // final profileBox = await Hive.openBox<ProfileData>(_profileBoxName);
    await profileBox.put(username, newProfile);
    print('Updated Profile data for $username');
  }

  /// Creates new profile data (after registration/setup)
  Future<void> createProfileData(String username, ProfileData profile) async {
    print('Creating profile data box for $username');
    await profileBox.put(username, profile);
    print('Created profile data box for $username');
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
