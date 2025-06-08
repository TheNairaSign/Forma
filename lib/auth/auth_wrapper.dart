import 'package:flutter/material.dart';
import 'package:workout_tracker/views/pages/auth/login_page.dart.dart';
import 'package:workout_tracker/views/pages/auth/sign_up_page.dart.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool showLogin = true;

  void toggleView() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLogin
      ? LoginPage(toggleView: toggleView)
      : SignUpPage(toggleView: toggleView);
  }
}