// ignore_for_file: avoid_print, use_build_context_synchronously


import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';
import 'package:workout_tracker/services/exceptions/network_exception.dart';
import 'package:workout_tracker/services/user_box_service.dart';

class SupabaseAuth {
  SupabaseAuth._privateConstructor();

  static final SupabaseAuth _instance = SupabaseAuth._privateConstructor();
  static SupabaseAuth get instance => _instance;

  final supabase = Supabase.instance.client;

  Future<void> _storeUser(User? user) async {
    final prefs = await SharedPreferences.getInstance();

    if (user != null) {
      final userString = jsonEncode(user.toJson());
      print('Storing user: $userString');
      try {
        await prefs.setString(user.id, userString);
      } catch (e) {
        print('Error storing user: $e');
      }
    }
  }

  Future<User?> getUserFromCache(String? userId) async {
    final prefs = await SharedPreferences.getInstance();
    print('Getting user from cache for user id: $userId');
    if (userId != null || userId!.isEmpty) {
      final user = prefs.getString(userId);
      if (user != null) {
        try {
          final userFromCache = User.fromJson(jsonDecode(user));
          final id = userFromCache?.id;
          await UserBoxService(id).getCaloriesBox();
          await UserBoxService(id).getStepsBox();
          return userFromCache;
        } catch (e) {
          print('Error decoding user from cache: $e');
        }
      }
    }
    return null;
  }

  bool? _isEmailConfirmed;
  bool? get isEmailConfirmed => _isEmailConfirmed;

  Future<bool> signIn(String email, String password, WidgetRef ref) async { 
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      print('Response received from supabase: ${response.user}');
      if (response.session != null) {
        print('User signed in successfully');
        _storeUser(response.user);
        _isEmailConfirmed = response.user?.userMetadata?['email_verified'];
        print('Email confirmed: $_isEmailConfirmed');
        print('User id: ${response.user?.id}');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('loggedIn', response.user!.email!);
        final userId = response.user?.id;
        ref.watch(profileDataProvider.notifier).updateProfileId(userId!);
        await UserBoxService(userId).getCaloriesBox();
        await UserBoxService(userId).getStepsBox();
        return true;
      }
    } on NetworkException catch (e) {
      print('Network Error: $e');
    } catch (error) {
      print('Error signing in with email and password: $error');
    }
    return false;
  }

  Future<User?> getUser() async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser != null) {
        print('User found: ${currentUser.toJson()}');
        await _storeUser(currentUser);
        _isEmailConfirmed = currentUser.userMetadata?['email_verified'];
        print('Email confirmed: $_isEmailConfirmed');
        return currentUser;
      } else {
        print('User not found');
      }
      return null;
    } on Exception catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      print('Response received from supabase: ${response.user}');
      if (response.user != null) {
        print('User signed up successfully with details: ${response.user.toString()}');
        _storeUser(response.user);
        return true;
      }
    } on Exception catch (e) {
      throw('Error Signing up: $e');
    }
    return false;
  }
}