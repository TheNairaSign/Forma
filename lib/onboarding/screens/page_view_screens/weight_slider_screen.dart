import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';
import 'package:workout_tracker/constants.dart';
import 'package:workout_tracker/onboarding/widgets/segmented_control_widget.dart';
import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';

class WeightSliderScreen extends ConsumerStatefulWidget {
  const WeightSliderScreen({super.key, this.isEdit = false, this.weight});
  final bool isEdit;
  final double? weight;

  @override
  ConsumerState<WeightSliderScreen> createState() => _WeightSliderScreenState();
}

class _WeightSliderScreenState extends ConsumerState<WeightSliderScreen> {
  bool isKg = true;
  late double weight;

  final double minWeight = 30;
  final double maxWeight = 200;

  late WeightSliderController _controller;
  // double _weight = 30.0;

  @override
  void initState() {
    weight = widget.weight ?? 70.0;
    super.initState();
    _controller = WeightSliderController(initialWeight: weight, minWeight: 0, interval: 0.1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final units = isKg ? "kg" : "lb";

    return Scaffold(
      appBar: widget.isEdit == true ? AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "How much do you weigh?",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 26),
        ),
      ) : null,
      body: Padding(
          padding: widget.isEdit == true ? bodyPadding : onboardingBodyPadding,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            if(widget.isEdit == false)
              Text(
                "How much do you weigh?",
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
              CustomSegmentedControl(
                option1: "KG", 
                option2: "LB", 
                selected: isKg, 
                onChanged: (val) => setState(() {
                  isKg = val;
                  ref.read(profileDataProvider.notifier).setWeight(context, isKg ? weight : weight * 0.453592);
                })
              ),
              const SizedBox(height: 30),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 30),
                decoration: BoxDecoration(
                  color: Color(0xfff7f6fb),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: weight.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 40, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: " ",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600])
                          ),
                          TextSpan(
                            text: units,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600])
                          )
                        ]
                      )
                    ),
                    VerticalWeightSlider(
                      isVertical: false,
                      height: 70,
                      haptic: Haptic.selectionClick,
                      controller: _controller,
                      decoration: const PointerDecoration(
                        // width: 130.0,
                        height: 3.0,
                        largeColor: Color(0xFF898989),
                        mediumColor: Color(0xFFC5C5C5),
                        smallColor: Color(0xFFF0F0F0),
                        gap: 30.0,
                      ),
                      onChanged: (double value) {
                        setState(() {
                          ref.read(profileDataProvider.notifier).setWeight(context, value);
                          weight = value;
                        });
                      },
                      indicator: Container(
                        height: 3.0,
                        // width: 200.0,
                        alignment: Alignment.centerLeft,
                        color: Colors.red[300],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ),
      bottomSheet: widget.isEdit == true ? SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: GlobalColors.primaryColor),
          onPressed: () {
            ref.read(profileDataProvider.notifier).setWeight(context, isKg ? weight : weight * 0.453592, isEdit: true);
            Navigator.pop(context);
          }, 
          child: Text('Save', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold))
        ),
      ) : null
    );
  }
}
