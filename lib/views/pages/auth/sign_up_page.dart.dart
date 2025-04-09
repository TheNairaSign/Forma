import 'package:flutter/material.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/utils/constants.dart';
import 'package:workout_tracker/utils/custom_route.dart';
import 'package:workout_tracker/views/pages/auth/login_page.dart.dart';
import 'package:workout_tracker/views/pages/auth/widgets/auth_logo_container.dart';
import 'package:workout_tracker/views/widgets/animated_page_entry.dart';
import 'package:workout_tracker/views/widgets/blue_button.dart';
import 'package:workout_tracker/views/widgets/custom_text_field.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacement(SlidePageRoute(page: const LoginPage(), reverse: true)),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: Constants.bodyPadding,
          child: AnimatedPageEntry(
            verticalOffset: 50,
              children: [
                Center(child: Text('FORMA', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: GlobalColors.primaryBlue))),
                const SizedBox(height: 40),

                Text('Create your Account', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 15),

                CustomTextField(hintText: 'Email', controller: controller, labelText: 'Email',),
                const SizedBox(height: 15),
                CustomTextField(hintText: 'Password', controller: controller, labelText: 'Password',),
                const SizedBox(height: 15),
                CustomTextField(hintText: 'Confirm Password', controller: controller, labelText: 'Confirm Password'),
                const SizedBox(height: 40),
                BlueButton(onPressed: () {}, text: 'Sign up'),
                const SizedBox(height: 40),
                Center(child: Text('- Or sign in with -', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),)),

                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AuthLogoContainer(onPressed: () {}, svgAsset: 'assets/google-logo.svg'),
                    AuthLogoContainer(onPressed: () {}, svgAsset: 'assets/facebook-logo.svg'),
                    AuthLogoContainer(onPressed: () {}, svgAsset: 'assets/twitter.svg'),
                  ],
                ),

                const SizedBox(height: 70),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      SlidePageRoute(page: LoginPage())
                    ),
                    child: Text("Login", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: GlobalColors.primaryBlue))),
                ],
              )
              ],
            ),
          ),
        ),
    );
  }
}