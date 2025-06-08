import 'package:flutter/material.dart';
import 'package:workout_tracker/constants.dart';
import 'package:workout_tracker/style/global_colors.dart';

class GenderIdentityScreen extends StatefulWidget {
  const GenderIdentityScreen({super.key});

  @override
  State<GenderIdentityScreen> createState() => _GenderIdentityScreenState();
}

class _GenderIdentityScreenState extends State<GenderIdentityScreen> {
  final List<Map<String, dynamic>> genderOptions = [
    {'icon': Icons.male, 'label': 'Male'},
    {'icon': Icons.female, 'label': 'Female'},
    {'icon': Icons.transgender, 'label': 'Non-Binary'},
    {'icon': Icons.close, 'label': 'Prefer Not to disclose'},
  ];

  bool selected = false;
  int selectedGenderIndex = -1;

  @override
  Widget build(BuildContext context) {
    bool isSelected(int index) => selectedGenderIndex == index;

    return Padding(
        padding: onboardingBodyPadding,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
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
                itemCount: genderOptions.length, 
                separatorBuilder: (context, index) => SizedBox(height: 20),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGenderIndex = index;
                      });
                    },
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected(index) ? GlobalColors.purple : Color(0xfff7f6fb),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(genderOptions[index]['icon'], color: isSelected(index)? Colors.white : Colors.grey[700], size: 25,),
                          SizedBox(width: 20),
                          Text(genderOptions[index]['label'], style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: isSelected(index)? Colors.white : Colors.grey[700]))
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