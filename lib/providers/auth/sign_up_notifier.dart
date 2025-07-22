// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/auth/supabase/email_confirmation_screen.dart';
import 'package:workout_tracker/auth/supabase/supabase_auth.dart';
import 'package:workout_tracker/utils/alerts.dart';

class SignUpNotifier extends StateNotifier<AsyncValue> {
  SignUpNotifier() : super(const AsyncValue.data(null));

  final _supabaseAuth = SupabaseAuth.instance;

  final TextEditingController _usernameController = TextEditingController();
  TextEditingController get usernameController => _usernameController;

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  final TextEditingController _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  final TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController get confirmPasswordController => _confirmPasswordController;

  void _validateFields(BuildContext context) {
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
  }

  Future<void> registerUser(BuildContext context) async {
    state = const AsyncValue.loading();

    _validateFields(context);

    state = await AsyncValue.guard(() => _supabaseAuth.signUp(
      displayName: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    ));

    if (state.hasError) {
      // Alerts.showErrorDialog(context, 'Registration Error', state.error.toString());
      debugPrint('Registration Error: ${state.error.toString()}');
      throw Exception('Registration Error: ${state.error.toString()}');
    } else {
      debugPrint('User Registered successfully');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => EmailConfirmationScreen(email: _emailController.text)
        ),
      );
    }
  }

}

final signUpProvider = StateNotifierProvider<SignUpNotifier, AsyncValue>((ref) => SignUpNotifier());