// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/services/auth_service.dart';
import 'package:workout_tracker/utils/alerts.dart';

class SignUpNotifier extends StateNotifier<AsyncValue> {
  SignUpNotifier() : super(AsyncLoading());

  final _authService = AuthService();

  final TextEditingController _usernameController = TextEditingController();
  TextEditingController get usernameController => _usernameController;

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  final TextEditingController _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  final TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController get confirmPasswordController => _confirmPasswordController;

  Future<void> registerUser(BuildContext context, PageController pageController) async {
    state = const AsyncValue.loading();

    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      state = const AsyncValue.error('Fill in all fields to continue', StackTrace.empty);
      Alerts.showErrorDialog(context, "Input Error", 'Fill in all fields to continue');
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      state = const AsyncValue.error('Passwords do not match', StackTrace.empty);
      Alerts.showErrorDialog(context, "Passwords mismatch", 'Passwords do not match');
      return;
    }

    state = await AsyncValue.guard(() => _authService.register(
      _usernameController.text,
      _emailController.text,
      _passwordController.text,
    ));

    if (state.hasError) {
      Alerts.showErrorDialog(context, 'Registration Error', state.error.toString());
    } else {
      debugPrint('User Registered successfully');
      pageController.previousPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeIn,
      ).then((_) {
        _usernameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
      });
    }
  }

}

final signUpProvider = StateNotifierProvider<SignUpNotifier, AsyncValue>((ref) => SignUpNotifier());