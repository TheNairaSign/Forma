import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lottie/lottie.dart';
import 'package:workout_tracker/providers/auth/login_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/utils/constants.dart';
import 'package:workout_tracker/views/widgets/animated_page_entry.dart';
import 'package:workout_tracker/views/widgets/blue_button.dart';
import 'package:workout_tracker/views/widgets/custom_text_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, required this.toggleView});
  final VoidCallback toggleView;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final animationDuration = Duration(milliseconds: 3000);
  final double from = 400;
  @override
  Widget build(BuildContext context) {
    final login = ref.read(loginProvider.notifier);
    return Scaffold(
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: Constants.bodyPadding,
          child: AnimatedPageEntry(
            verticalOffset: 50,
            duration: Duration(milliseconds: 400),
              children: [
                Center(child: Text('Forma', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: GlobalColors.primaryColor))),
                const SizedBox(height: 20),
            
                Text('Login to your Account', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                // const SizedBox(height: 15),

                // Lottie.asset('assets/lottie/workout-duo-animation.json'),

                const SizedBox(height: 30),

                CustomTextField(hintText: 'Email', controller: login.emailController, labelText: 'Email',),
                const SizedBox(height: 15),
                CustomTextField(hintText: 'Password', controller: login.passwordController, labelText: 'Password',),
                const SizedBox(height: 25),
                BlueButton(onPressed: () => login.loginUser(context), text: 'Login'),
                const SizedBox(height: 50),
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.toggleView,
                      child: Text("Sign up", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: GlobalColors.primaryColor, decoration: TextDecoration.underline))),
                  ],
                ),
              ],
            ),
          ),
        ),
        // bottomSheet: CustomBottomSheet(),
    );
  }
}