import 'package:flutter/material.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/utils/constants.dart';
import 'package:workout_tracker/utils/custom_route.dart';
import 'package:workout_tracker/views/pages/auth/sign_up_page.dart.dart';
import 'package:workout_tracker/views/pages/auth/widgets/auth_logo_container.dart';
import 'package:workout_tracker/views/pages/navigation/navigation_page.dart';
import 'package:workout_tracker/views/widgets/animated_page_entry.dart';
import 'package:workout_tracker/views/widgets/blue_button.dart';
import 'package:workout_tracker/views/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller =  TextEditingController();
  final animationDuration = Duration(milliseconds: 3000);
  final double from = 400;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xfff5f8fe),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: Constants.bodyPadding,
          child:AnimatedPageEntry(
            verticalOffset: 50,
              children: [
                const SizedBox(height: 40),
                Center(child: Text('FORMA', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: GlobalColors.primaryBlue))),
                const SizedBox(height: 40),
            
                Text('Login to your Account', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 15),
            
                CustomTextField(hintText: 'Email', controller: controller, labelText: 'Email',),
                const SizedBox(height: 15),
                CustomTextField(hintText: 'Password', controller: controller, labelText: 'Password',),
                const SizedBox(height: 40),
                BlueButton(onPressed: () => Navigator.of(context).pushReplacement(SlidePageRoute(page: NavigationPage())), text: 'Login'),
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
                    Text("Don't have an account?", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(SlidePageRoute(page: SignUpPage())),
                      child: Text("Sign up", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: GlobalColors.primaryBlue))),
                  ],
                )
              ],
            ),
          ),
        ),
    );
  }
}