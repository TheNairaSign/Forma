import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workout_tracker/auth/user_logged_in.dart';
import 'package:workout_tracker/services/onboarding_service.dart';
import 'package:workout_tracker/views/pages/auth/auth_page.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    final onboardingService = OnboardingService.instance;

    if (session != null) {
      // ✅ User is signed in
      return const UserLoggedIn();
    } else {
      // ❌ No user signed in
      onboardingService.clearOnboardingStatus(session?.user.id);
      return const AuthPage();
    }
  }
}
