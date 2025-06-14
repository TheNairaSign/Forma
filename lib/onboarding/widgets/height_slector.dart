import 'package:flutter/material.dart';
import 'package:workout_tracker/onboarding/widgets/segmented_control_widget.dart';

class HeightSelector extends StatefulWidget {
  const HeightSelector({super.key});

  @override
  State<HeightSelector> createState() => _HeightSelectorState();
}

class _HeightSelectorState extends State<HeightSelector> {
  bool isCm = true;
  int cmValue = 175;

  final int minCm = 100;
  final int maxCm = 220;

  FixedExtentScrollController cmController = FixedExtentScrollController();

  @override
  void initState() {
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
    return Column(
      children: [
        // Toggle switch
        CustomSegmentedControl(option1: 'CM', option2: 'FT', selected: isCm, onChanged: (value) {
          setState(() {
            isCm = value;
          });
        }),
        const SizedBox(height: 30),

        // Height display
        Text(
          displayHeight,
          style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
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
                          color: isSelected ? Colors.deepPurple : Colors.black54,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                right: 4,
                child: Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
