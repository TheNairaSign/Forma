import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:workout_tracker/constants.dart';
import 'package:workout_tracker/models/enums/food_preference.dart';
import 'package:workout_tracker/providers/profile_data_notifier.dart';

class FoodPreferenceScreen extends ConsumerStatefulWidget {
  const FoodPreferenceScreen({super.key});

  @override
  ConsumerState<FoodPreferenceScreen> createState() => _FoodPreferenceScreenState();
}

class _FoodPreferenceScreenState extends ConsumerState<FoodPreferenceScreen> {

  final Set<String> selectedItems = {};

  void toggleSelection(String name) {
    setState(() {
      if (selectedItems.contains(name)) {
        selectedItems.remove(name);
        ref.watch(profileDataProvider.notifier).setFoodPreference(selectedItems.toList());
      } else {
        selectedItems.add(name);
        ref.watch(profileDataProvider.notifier).setFoodPreference(selectedItems.toList());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF8265FF);

    return Padding(
      padding: onboardingBodyPadding,
      child: Column(
        children: [
          Text(
            "This is used in getting & personalized results\n& plans for you",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 30),

          /// Wrap Layout
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: FoodPreference.values.map((category) {
              final isSelected = selectedItems.contains(category.name);
              return GestureDetector(
                onTap: () => toggleSelection(category.name),
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: isSelected ? themeColor : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        category.icon,
                        height: 35,
                        width: 35,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.name.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}