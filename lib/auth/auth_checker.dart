
import 'package:flutter/material.dart';
import 'package:workout_tracker/services/auth_service.dart';
import 'package:workout_tracker/views/pages/auth/auth_page.dart';
import 'package:workout_tracker/views/pages/navigation/navigation_future_page.dart';


class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  final AuthService _authService = AuthService();
  late Future<bool> _isLoggedInFuture;

  @override
  void initState() {
    super.initState();
    _isLoggedInFuture = _authService.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedInFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Error checking authentication state'),
            ),
          );
        } else {
          final isLoggedIn = snapshot.data ?? false;

          return isLoggedIn ? const NavigationFuturePage() : const AuthPage();
        }
      },
    );
  }
}
