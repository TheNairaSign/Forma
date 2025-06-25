import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/constants.dart';
import 'package:workout_tracker/providers/profile_data_notifier.dart';

class AgeSliderScreen extends ConsumerStatefulWidget {
  const AgeSliderScreen({super.key});

  @override
  ConsumerState<AgeSliderScreen> createState() => _AgeSliderScreenState();
}

class _AgeSliderScreenState extends ConsumerState<AgeSliderScreen> {
  int selectedAge = 25; // Default selected age
  final List<int> ageRange = List.generate(100, (index) => index + 1);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: onboardingBodyPadding,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What\'s your age?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'This is used in getting personalised results\nand plans for you.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          ),
          SizedBox(height: 70),
          Center(
            child: Container(
              height: 300,
              width: 140,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
              ),
              child: CupertinoPicker(
                diameterRatio: 1,
                backgroundColor: const Color(0xFFF7F7F7),
                useMagnifier: true,
                itemExtent: 50,
                scrollController: FixedExtentScrollController(initialItem: selectedAge - 1),
                onSelectedItemChanged: (int index) {
                  setState(() {
                    ref.read(profileDataProvider.notifier).setAge(ageRange[index]);
                    selectedAge = ageRange[index];
                  });
                },
                children: ageRange.map((age) {
                  return Center(
                    child: Text(
                      age.toString(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 22,
                        fontWeight: selectedAge == age ? FontWeight.bold : FontWeight.normal,
                        color: selectedAge == age ? Colors.black : Colors.grey,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
