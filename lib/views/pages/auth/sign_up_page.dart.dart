import 'package:flutter/material.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/utils/constants.dart';
import 'package:workout_tracker/views/widgets/animated_page_entry.dart';
import 'package:workout_tracker/views/widgets/blue_button.dart';
import 'package:workout_tracker/views/widgets/custom_text_field.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key, required this.toggleView});
  final VoidCallback toggleView;

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
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

              Text('Create your Account', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),

              // Lottie.asset('assets/lottie/workout-duo-animation.json'),
              // const SizedBox(height: 30),

              CustomTextField(hintText: 'Username', controller: controller, labelText: 'Username'),
              const SizedBox(height: 15),
              CustomTextField(hintText: 'Email', controller: controller, labelText: 'Email'),
              const SizedBox(height: 15),
              CustomTextField(hintText: 'Password', controller: controller, labelText: 'Password',),
              const SizedBox(height: 15),
              CustomTextField(hintText: 'Confirm Password', controller: controller, labelText: 'Confirm Password'),
              const SizedBox(height: 25),
              BlueButton(onPressed: () {}, text: 'Sign up'),
              const SizedBox(height: 30),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: toggleView,
                    child: Text("Login", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: GlobalColors.primaryColor, decoration: TextDecoration.underline))),
                ],
              )
              ],
            ),
          ),
        ),
    );
  }
}