// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/providers/auth/sign_up_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/views/pages/auth/widgets/auth_text_fields.dart';

class SignupCard extends ConsumerWidget {
  const SignupCard({super.key, required this.controller});
  final PageController controller;

  void toggleScreens() {
    controller.previousPage(
      duration: Duration(milliseconds: 400), 
      curve: Curves.easeIn,
    );
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signup = ref.watch(signUpProvider.notifier);
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
                AuthTextField(hintText: 'Username', svgAsset: 'account-avatar-head', controller: signup.usernameController),

                const SizedBox(height: 12),

                // Email field
                AuthTextField(hintText: 'Email', svgAsset: 'at', controller: signup.emailController),
                

                const SizedBox(height: 12),

                // Password field
                AuthTextField(
                  hintText: 'Password', 
                  svgAsset: 'lock', 
                  controller: signup.passwordController,
                  showSuffix: true,
                  obscure: true,
                ),
                const SizedBox(height: 12),
                AuthTextField(
                  hintText: 'Confirm Password',
                  svgAsset: 'lock',
                  controller: signup.confirmPasswordController,
                  showSuffix: true,
                  obscure: true,
                ),


                const SizedBox(height: 25),

                // Signup button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => signup.registerUser(context, controller),
                    // onPressed: () async {
                    //   final isSignIn = await SupabaseAuth.instance.signUp(
                    //     signup.emailController.text, 
                    //     signup.passwordController.text,
                    //   );
                    //   if (isSignIn) {
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(
                    //         builder: (ctx) => EmailConfirmationScreen(email: signup.emailController.text)
                    //       ),
                    //     );
                    //   }
                    // },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalColors.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                    behavior: HitTestBehavior.opaque,
                    onTap: toggleScreens,
                    child: Text("Login", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: GlobalColors.primaryColor, decoration: TextDecoration.underline)),
                  ),
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
