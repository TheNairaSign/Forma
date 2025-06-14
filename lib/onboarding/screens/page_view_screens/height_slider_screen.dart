import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';
import 'package:workout_tracker/constants.dart';
import 'package:workout_tracker/onboarding/widgets/height_slector.dart';

class HeightSliderScreen extends ConsumerStatefulWidget {
  const HeightSliderScreen({super.key});

  @override
  ConsumerState<HeightSliderScreen> createState() => HeightSliderScreenState();
}

class HeightSliderScreenState extends ConsumerState<HeightSliderScreen> {
  bool isCm = true;
  double height = 75;


  late WeightSliderController _controller;
  final double _height = 165.0;

// Convert cm to feet and inches
  String cmToFeet(double cm) {
    double inches = cm / 2.54;
    int feet = (inches / 12).floor();
    double remainingInches = inches % 12;
    return '$feet\' ${remainingInches.toStringAsFixed(1)}"';
  }

// Convert feet and inches to cm
  double feetToCm(double feet) {
    double inches = feet * 12;
    return inches * 2.54;
  }

  @override
  void initState() {
    super.initState();
    _controller = WeightSliderController(initialWeight: _height, minWeight: 0, interval: 0.1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: onboardingBodyPadding,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How tall are you?",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "This is used to set up recommendations\njust for you.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            HeightSelector()
          ],
        ),
    );
  }
}
