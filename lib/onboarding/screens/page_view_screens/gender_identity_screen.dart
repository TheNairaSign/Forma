import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/constants.dart';
import 'package:workout_tracker/models/enums/gender.dart';
import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';

class GenderIdentityScreen extends ConsumerStatefulWidget {
  const GenderIdentityScreen({super.key});

  @override
  ConsumerState<GenderIdentityScreen> createState() => _GenderIdentityScreenState();
}

class _GenderIdentityScreenState extends ConsumerState<GenderIdentityScreen> {
  bool selected = false;
  int selectedGenderIndex = -1;

  @override
  Widget build(BuildContext context) {
    bool isSelected(int index) => selectedGenderIndex == index;

    return Padding(
      padding: onboardingBodyPadding,
      child: Column(
        children: [
          Text(
            'How do you identify?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'To give you a better experience we need to\nknow your gender.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          ),
          SizedBox(height: 40),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: gender.length,
              separatorBuilder: (context, index) => SizedBox(height: 20),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      ref.read(profileDataProvider.notifier).updateGender(Gender.values[index].name);
                      selectedGenderIndex = index;
                    });
                  },
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected(index) ? GlobalColors.primaryColorLight : Color(0xfff7f6fb),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Icon(Gender.values[index].icon, color: isSelected(index) ? Colors.black : Colors.grey[700], size: 25,),
                        SizedBox(width: 20),
                        Text(Gender.values[index].name, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: isSelected(index) ? Colors.black : Colors.grey[700]))
                      ]
                    )
                  )
                );
              },
            ),
          )
        ],
      ),
    );
  }
}