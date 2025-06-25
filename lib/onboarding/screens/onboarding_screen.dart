import 'package:flutter/material.dart';
import 'package:workout_tracker/constants.dart';
import 'package:workout_tracker/onboarding/screens/avatar_page.dart';
import 'package:workout_tracker/onboarding/screens/page_view_screens/age_slider_screen.dart';
import 'package:workout_tracker/onboarding/screens/page_view_screens/food_preference_screen.dart';
import 'package:workout_tracker/onboarding/screens/page_view_screens/gender_identity_screen.dart';
// import 'package:workout_tracker/onboarding/screens/page_view_screens/goal_screen.dart';
import 'package:workout_tracker/onboarding/screens/page_view_screens/height_slider_screen.dart';
import 'package:workout_tracker/onboarding/screens/page_view_screens/weight_slider_screen.dart';
import 'package:workout_tracker/onboarding/widgets/custom_bottom_sheet.dart';
import 'package:workout_tracker/style/global_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final List<Widget> screens = [
    GenderIdentityScreen(),
    AgeSliderScreen(),
    WeightSliderScreen(),
    HeightSliderScreen(),
    FoodPreferenceScreen(),
    // GoalScreen()
  ];

  void toggleScreens() {
    if (_currentPage == screens.length - 1) {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const PickAvatarPage()));
    } else {
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  final PageController _pageController = PageController();
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: bodyPadding,
              child: Row(
                children: List.generate(screens.length, (index) {
                  return Expanded(
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      height: 4,
                      decoration: BoxDecoration(
                        color: index <= _currentPage ? GlobalColors.primaryColor : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
        
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: screens,
              )
            )
          ],
        ),
      ),
      bottomSheet: CustomBottomSheet(
        currentPage: _currentPage, 
        pages: screens.length, 
        onPressed: () => toggleScreens(),
      ),
    );
  }
}