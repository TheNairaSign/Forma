import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:workout_tracker/onboarding/widgets/custom_bottom_sheet.dart';
import 'package:workout_tracker/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: Constants.bodyPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeTransition(
                opacity: _fadeIn,
                child: Text(
                  'Forma',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff7064e3),
                  ),
                ),
              ),
              const Spacer(),
              Lottie.asset('assets/lottie/workout-duo-animation.json'),
              const SizedBox(height: 40),
              FadeTransition(
                opacity: _fadeIn,
                child: Text(
                  'Welcome, Champion!',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              FadeTransition(
                opacity: _fadeIn,
                child: Text(
                  'Crush your fitness goals, one rep at a time.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FadeTransition(
                opacity: _fadeIn,
                child: Text(
                  'Track, train, transform — let’s make every workout count!',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              const Spacer()
            ],
          ),
        ),
      ),
      bottomSheet: CustomBottomSheet(),
    );
  }
}
