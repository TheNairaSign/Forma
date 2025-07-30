import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/services/auth_service.dart';
import 'package:workout_tracker/views/pages/auth/auth_page.dart';
import 'package:workout_tracker/views/pages/navigation/navigation_future_page.dart';

class UserLoggedIn extends ConsumerWidget {
  const UserLoggedIn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<bool>(
      future: ref.watch(authServiceProvider).isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData && snapshot.data == true) {
          return const NavigationFuturePage();
        } else {
          return const AuthPage();
        }
      },
    );
  }
}