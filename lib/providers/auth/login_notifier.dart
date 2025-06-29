// ignore_for_file: use_build_context_synchronously

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/onboarding/screens/onboarding_screen.dart';
import 'package:workout_tracker/services/auth_service.dart';
import 'package:workout_tracker/utils/alerts.dart';
import 'package:workout_tracker/utils/custom_route.dart';

class LoginNotifier extends StateNotifier<AsyncValue> {
  LoginNotifier() : super(const AsyncValue.data(null));


  final _authService = AuthService();

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

    state = await AsyncValue.guard(() => _authService.login(_emailController.text, _passwordController.text));

    if (state.hasError) {
      Alerts.showErrorDialog(context, 'Login Error', state.error.toString());
    } else {
      Navigator.of(context).push(SlidePageRoute(page: OnboardingScreen()));
    }
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, AsyncValue>((ref) => LoginNotifier());