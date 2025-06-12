import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';
import 'package:workout_tracker/constants.dart';

class HeightSliderScreen extends StatefulWidget {
  const HeightSliderScreen({super.key});

  @override
  State<HeightSliderScreen> createState() => HeightSliderScreenState();
}

class HeightSliderScreenState extends State<HeightSliderScreen> {
  bool isKg = true;
  double weight = 75;

  final double minWeight = 30;
  final double maxWeight = 200;

  late WeightSliderController _controller;
  double _weight = 30.0;

  @override
  void initState() {
    super.initState();
    _controller = WeightSliderController(initialWeight: _weight, minWeight: 0, interval: 0.1);
  }

  @override

  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final units = isKg ? "kg" : "lb";
    final step = 1.0;

    return Padding(
        padding: onboardingBodyPadding,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How much your weight?",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "This is used to set up recommendations\njust for you.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // Toggle between KG and LB
            CupertinoSegmentedControl<bool>(
              children: const {
                true: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text("CM"),
                ),
                false: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text("FT"),
                ),
              },
              groupValue: isKg,
              onValueChanged: (val) {
                setState(() {
                  isKg = val;
                  weight = isKg ? 75 : 165; // default switch weight
                });
              },
              selectedColor: Colors.deepPurple,
              unselectedColor: Colors.white,
              borderColor: Colors.deepPurple,
              pressedColor: Colors.deepPurple.withOpacity(0.2),
            ),
            const SizedBox(height: 30),
            RichText(
              text: TextSpan(
                text: _weight.toStringAsFixed(1),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 40, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: " ",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600])
                  ),
                  TextSpan(
                    text: 'cm',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600])
                  )
                ]
              )
            ),
            const SizedBox(height: 10),
            Container(
              width: 130,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Color(0xfff7f6fb),
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: VerticalWeightSlider(
                height: 350,
                haptic: Haptic.selectionClick,
                controller: _controller,
                decoration: const PointerDecoration(
                  height: 3.0,
                  largeColor: Color(0xFF898989),
                  mediumColor: Color(0xFFC5C5C5),
                  smallColor: Color(0xFFF0F0F0),
                  gap: 30.0,
                ),
                onChanged: (double value) {
                  setState(() {
                    _weight = value;
                  });
                },
                indicator: Container(
                  height: 3.0,
                  alignment: Alignment.centerLeft,
                  color: Colors.red[300],
                ),
              ),
            ),
          ],
        ),
    );
  }
}
