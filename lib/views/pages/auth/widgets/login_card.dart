import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/providers/auth/login_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/views/pages/auth/widgets/auth_text_fields.dart';

class LoginCard extends ConsumerWidget {
  const LoginCard({super.key, required this.controller});
  final PageController controller;

  void toggleScreens() {
    controller.nextPage(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final login = ref.read(loginProvider.notifier);
    final state = ref.watch(loginProvider);
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
                  "Hello, please log in to access your membership",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Email field
                AuthTextField(hintText: 'e-mail address', svgAsset: 'at', controller: login.emailController,),

                const SizedBox(height: 15),

                AuthTextField(hintText: 'Password', svgAsset: 'key', controller: login.passwordController,),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (state is AsyncLoading) {
                        null;
                      }
                      login.loginUser(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalColors.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(
                      state is AsyncLoading? "Loading..." : "Log in", 
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: toggleScreens,
                      child: Text("Sign up", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: GlobalColors.primaryColor, decoration: TextDecoration.underline))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}