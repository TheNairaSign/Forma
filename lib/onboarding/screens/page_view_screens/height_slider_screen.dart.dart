import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/constants.dart';
import 'package:workout_tracker/onboarding/widgets/segmented_control_widget.dart';
import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';

class HeightSliderScreen extends ConsumerStatefulWidget {
  const HeightSliderScreen({super.key, this.isEdit = false});
  final bool isEdit;

  @override
  ConsumerState<HeightSliderScreen> createState() => _HeightSliderScreenState();
}

class _HeightSliderScreenState extends ConsumerState<HeightSliderScreen> {
  bool isCm = true;
  late int cmValue;

  final int minCm = 100;
  final int maxCm = 220;

  FixedExtentScrollController cmController = FixedExtentScrollController();

  @override
  void initState() {
    cmValue = ref.read(profileDataProvider).height?.truncate() ?? 170;
    super.initState();
    cmController = FixedExtentScrollController(initialItem: cmValue - minCm);
  }

  String get displayHeight {
    if (isCm) return "$cmValue cm";

    // Convert to ft + inches
    final inches = cmValue / 2.54;
    final feet = inches ~/ 12;
    final remainingInches = inches % 12;
    return "$feet’ ${remainingInches.toStringAsFixed(1)}\"";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isEdit == true ? AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "How tall are you?",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 26),
        ),
      ) : null,
      body: Padding(
        padding: widget.isEdit == true ? bodyPadding : onboardingBodyPadding,
        child: Column(
          children: [
            if(widget.isEdit == false)
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
            CustomSegmentedControl(option1: 'CM', option2: 'FT', selected: isCm, onChanged: (value) {
              setState(() {
                isCm = value;
              });
            }),
            const SizedBox(height: 30),
        
            // Height display
            Text(
              displayHeight,
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
            ),
        
            const SizedBox(height: 20),
        
            // Scroll wheel
            SizedBox(
              height: 300,
              width: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  ListWheelScrollView.useDelegate(
                    controller: cmController,
                    itemExtent: 50,
                    useMagnifier: true,
                    physics: const FixedExtentScrollPhysics(),
                    diameterRatio: 1.5,
                    magnification: 1.2,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        cmValue = minCm + index;
                        ref.read(profileDataProvider.notifier).setHeight(context, cmValue.toDouble());
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: maxCm - minCm + 1,
                      builder: (context, index) {
                        final value = minCm + index;
                        final isSelected = value == cmValue;
                        return Center(
                          child: Text(
                            '$value',
                            style: TextStyle(
                              fontSize: isSelected ? 22 : 16,
                              color: isSelected ? GlobalColors.primaryColor : Colors.black54,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    right: 4,
                    child: Icon(Icons.arrow_drop_down, color: GlobalColors.primaryColor),
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
          style: ElevatedButton.styleFrom(
            backgroundColor: GlobalColors.primaryColor,
          ),
          onPressed: () {
            ref.read(profileDataProvider.notifier).setHeight(context,  cmValue.toDouble(), isEdit: true);
            Navigator.pop(context);
          }, 
          child: Text('Save', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold))
        ),
      ) : null
    );
  }
}
