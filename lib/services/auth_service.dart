// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _userBoxName = 'usersBox';
  static const _sessionKey = 'loggedInUser';

  /// Hashes the password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  /// Registers a new user (username + password)
  Future<void> register(String username, String email, String password) async {
    final box = await Hive.openBox(_userBoxName);

    if (box.containsKey(username)) {
      throw AuthException('User already exists');
    }

    final hashedPassword = _hashPassword(password);

    await box.put(username, {
      'email': email,
      'password': hashedPassword,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  /// Logs in the user
  Future<void> login(String email, String password) async {
    final box = await Hive.openBox(_userBoxName);

    // Find user by email by iterating over the box
    String? username;
    dynamic userValue;
    for (final key in box.keys) {
      final value = box.get(key);
      if (value is Map && value['email'] == email) {
        username = key as String?;
        userValue = value;
        break;
      }
    }

    if (userValue == null) {
      throw AuthException('User not found');
    }

    final hashedInput = _hashPassword(password);
    final storedHash = userValue['password'];

    if (hashedInput != storedHash) {
      throw AuthException('Invalid credentials');
    }

    // store session with SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, username!);
  }

  /// Checks if a user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_sessionKey);
  }

  /// Gets the currently logged in username
  Future<String?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey);
  }

  /// Logs the user out
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}