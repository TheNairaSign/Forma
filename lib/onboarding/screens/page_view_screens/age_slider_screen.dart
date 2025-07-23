import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/constants.dart';
import 'package:workout_tracker/providers/profile/edit_data_provider.dart';
import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';

class AgeSliderScreen extends ConsumerStatefulWidget {
  const AgeSliderScreen({super.key, this.isEdit = false});
  final bool isEdit;

  @override
  ConsumerState<AgeSliderScreen> createState() => _AgeSliderScreenState();
}

class _AgeSliderScreenState extends ConsumerState<AgeSliderScreen> {
  late int selectedAge;
  final List<int> ageRange = List.generate(100, (index) => index + 1);

  @override
  void initState() {
    selectedAge = ref.read(profileDataProvider.notifier).age ?? 25;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isEdit == true ? AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "What's your age?",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 26),
        ),
      ) : null,
      body: Padding(
        padding: widget.isEdit == true ? bodyPadding : onboardingBodyPadding,
        child: Column(
          children: [
            if(widget.isEdit == false)
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
                      selectedAge = ageRange[index];
                      ref.read(profileDataProvider.notifier).setAge(selectedAge);
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
      ),
      bottomSheet: widget.isEdit == true ? SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: GlobalColors.primaryColor,
          ),
          onPressed: () {
            // If in edit mode, use the edit_data_provider to update the age
            if (widget.isEdit) {
              final profile = ref.read(profileDataProvider);
              ref.read(editDataProvider(profile).notifier).updateAge(selectedAge, context);
            } else {
              // Otherwise, use the profile_data_provider directly
              ref.read(profileDataProvider.notifier).setAge(selectedAge);
            }
            Navigator.pop(context);
          }, 
          child: Text('Save', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold))
        ),
      ) : null
    );
  }
}
