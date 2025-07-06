// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:workout_tracker/views/pages/auth/widgets/login_card.dart';
import 'package:workout_tracker/views/pages/auth/widgets/signup_card.dart';

void main() => runApp(const MaterialApp(home: AuthPage()));

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/stretch-cover-image.jpg'), // Replace with your background
                fit: BoxFit.cover,
              ),
            ),
          ),

          // PageView for Login/Signup
          PageView(
            controller: _controller,
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: [
              LoginCard(controller: _controller),
              SignupCard(controller: _controller),
            ],
          ),
        ],
      ),
    );
  }
}



