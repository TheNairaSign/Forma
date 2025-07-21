// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/auth/supabase/supabase_auth.dart';
import 'package:workout_tracker/onboarding/screens/onboarding_screen.dart';
import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';
import 'package:workout_tracker/utils/alerts.dart';
import 'package:workout_tracker/utils/custom_route.dart';
import 'package:workout_tracker/views/pages/auth/auth_page.dart';
import 'package:workout_tracker/views/pages/navigation/navigation_future_page.dart';

class LoginNotifier extends StateNotifier<AsyncValue> {
  final Ref ref;
  LoginNotifier(this.ref) : super(const AsyncValue.data(null));


  final _supabaseAuth = SupabaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  final TextEditingController _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  Future<void> loginUser(BuildContext context) async {
    state = const AsyncValue.loading();

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      state = const AsyncValue.error('Fill in all fields to continue', StackTrace.empty);
      Alerts.showErrorDialog(context, 'Input Error', 'Fill in all fields to continue');
      return;
    }

    // state = await AsyncValue.guard(() => _supabaseAuth.signIn(_emailController.text, _passwordController.text, ref));

    try {
      final response = await _supabaseAuth.signIn(_emailController.text, _passwordController.text, ref);

      if (response) {
        state = const AsyncValue.data(true);
        if (await ref.watch(profileDataProvider.notifier).onBoardingCompleted()) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => NavigationFuturePage()));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => OnboardingScreen()));
        }
        
      } else {
        state = const AsyncValue.error('Invalid Credentials', StackTrace.empty);
        Alerts.showErrorDialog(context, 'Invalid Credentials', 'Please check your email and password.');
        return;
      }
    } catch (error) {
      throw Exception('Login Error: $error');
    }

    if (_supabaseAuth.isEmailConfirmed != true) {
      Alerts.showErrorDialog(context, 'Email not confirmed', 'Please check your email and confirm your account.');
      state = const AsyncValue.error('Email not confirmed', StackTrace.empty);
      return;
    }

    if (state.hasError) {
      // Alerts.showErrorDialog(context, 'Login Error', state.error.toString());
      throw Exception('Login Error: ${state.error.toString()}');
      
    } else {
      Navigator.of(context).push(SlidePageRoute(page: OnboardingScreen()));
    }
  }

  Future<void> logoutUser(BuildContext context) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() => _supabaseAuth.signOut());

    if (state.hasError) {
      Alerts.showErrorDialog(context, 'Logout Error', state.error.toString());
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        SlidePageRoute(page: AuthPage()),
        (route) => false,
      );
    }
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, AsyncValue>((ref) => LoginNotifier(ref));