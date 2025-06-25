import 'package:flutter/material.dart';
import 'package:workout_tracker/views/pages/auth/widgets/auth_text_fields.dart';

class SignupCard extends StatelessWidget {
  const SignupCard({super.key, required this.controller});
  final PageController controller;

  void toggleScreens() {
    controller.previousPage(
      duration: Duration(milliseconds: 400), 
      curve: Curves.easeIn,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            color: Colors.white.withOpacity(0.85),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Create your account to get started",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Name field
                AuthTextField(hintText: 'Full name', svgAsset: 'account-avatar-head'),

                const SizedBox(height: 12),

                // Email field
                AuthTextField(hintText: 'e-mail address', svgAsset: 'at',),
                

                const SizedBox(height: 12),

                // Password field
                AuthTextField(hintText: 'Password', svgAsset: 'lock'),


                const SizedBox(height: 25),

                // Signup button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text("Register", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: toggleScreens,
                    child: Text("Login", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black, decoration: TextDecoration.underline))),
                ],
              )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
