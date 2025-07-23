import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';
import 'package:workout_tracker/views/pages/activity/activity_page.dart';
import 'package:workout_tracker/views/pages/home/home_page.dart';
import 'package:workout_tracker/views/pages/workouts/workouts_page.dart';
import 'package:workout_tracker/views/pages/navigation/widgets/nav_destination.dart';
import 'package:workout_tracker/views/pages/profile/profile_page.dart';

class NavigationPage extends ConsumerStatefulWidget {
  const NavigationPage({super.key});

  @override
  ConsumerState<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends ConsumerState<NavigationPage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;
  late AnimationController _animationController;
  
  final List<Widget> _pages = [
    const HomePage(),
    const WorkoutsPage(),
    const CalorieDetailsPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    ref.read(profileDataProvider.notifier).loadProfileData();
    // ref.read(workoutItemProvider.notifier).getWorkoutsForDay(DateTime.now());
    _pageController = PageController(initialPage: _selectedIndex);
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) { 
    if (index == _selectedIndex) return;
    
    _animationController.forward(from: 0.0);
    
    setState(() {
      _selectedIndex = index;
    });
    
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: SafeArea(
        child: NavDestination(
          onDestinationSelected: _onItemTapped,
          selectedIndex: _selectedIndex,
        ),
      ),
    );
  }
}