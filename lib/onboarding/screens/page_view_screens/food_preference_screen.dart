import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:workout_tracker/constants.dart';
import 'package:workout_tracker/models/enums/food_preference.dart';
import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/utils/flush/flushbar_service.dart';

class FoodPreferenceScreen extends ConsumerStatefulWidget {
  const FoodPreferenceScreen({super.key, this.isEdit = false});
  final bool isEdit;

  @override
  ConsumerState<FoodPreferenceScreen> createState() => _FoodPreferenceScreenState();
}

class _FoodPreferenceScreenState extends ConsumerState<FoodPreferenceScreen> {

  Set<String> selectedItems = {};

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileDataProvider).value;
    final foodPref = profile?.foodPreference;
    if(foodPref != null) {
      debugPrint('Food Preference not null with values: $foodPref');
      selectedItems.addAll(foodPref);
    }
  }

  void toggleSelection(String name) {
    setState(() {
      if (selectedItems.contains(name)) {
        selectedItems.remove(name);
        ref.watch(profileDataProvider.notifier).setFoodPreference(context, selectedItems.toList());
      } else {
        selectedItems.add(name);
        ref.watch(profileDataProvider.notifier).setFoodPreference(context, selectedItems.toList());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final themeColor = const Color(0xFF8265FF);
    final themeColor = GlobalColors.primaryColorLight;

    return Scaffold(
      appBar: widget.isEdit == true ? AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "What do you like?",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 26),
        ),
      ) : null,
      body: Padding(
        padding: onboardingBodyPadding,
        child: Column(
          children: [
            if(widget.isEdit == false)
            Text(
              'What do you like?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 26, fontWeight: FontWeight.bold),
            ),
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
                            color: Colors.black87,
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
      ),

      bottomSheet: widget.isEdit == true ? SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: GlobalColors.primaryColor),
          onPressed: () {
            ref.watch(profileDataProvider.notifier).setFoodPreference(context, selectedItems.toList(), isEdit: true);
            Navigator.pop(context);
            FlushbarService.show(context, message: 'Height updated successfully');
          }, 
          child: Text('Save', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold))
        ),
      ) : null
    );
  }
}