import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class NavDestination extends StatefulWidget {
  const NavDestination({super.key, required this.onDestinationSelected, required this.selectedIndex});
  final int selectedIndex;
  final void Function(int index) onDestinationSelected;

  @override
  State<NavDestination> createState() => _NavDestinationState();
}

class _NavDestinationState extends State<NavDestination> {
  final iconColor = Colors.black;

  final List<NavigationDestination> _destinations = [
    const NavigationDestination(
      icon: Icon(Icons.home_outlined, color: Colors.grey,),
      selectedIcon: Icon(Icons.home, color: Colors.black,),
      label: 'Home',
    ),
    const NavigationDestination(
      icon: Icon(Icons.fitness_center_outlined, color: Colors.grey,),
      selectedIcon: Icon(Icons.fitness_center, color: Colors.black,),
      label: 'Workouts',
    ),
    const NavigationDestination(
      icon: Icon(Icons.analytics_outlined, color: Colors.grey,),
      selectedIcon: Icon(Icons.analytics, color: Colors.black,),
      label: 'Progress',
    ),
    const NavigationDestination(
      icon: Icon(Icons.person_outline, color: Colors.grey,),
      selectedIcon: Icon(Icons.person, color: Colors.black),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return  NavigationBar(
        selectedIndex: widget.selectedIndex,
        onDestinationSelected: (index) => widget.onDestinationSelected(index),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.bodySmall),
        destinations: List.generate(_destinations.length, (index) => _destinations[index]),
        // destinations: List.generate(
        //   _destinations.length,
        //   (index) => AnimationConfiguration.staggeredList(
        //     position: index,
        //     duration: const Duration(milliseconds: 600),
        //     child: SlideAnimation(
        //       horizontalOffset: 50.0,
        //       child: FadeInAnimation(child: _buildAnimatedDestination(index)),
        //     ),
        //   ),
        // ),
    );
  }

  // Create animated destination items
  Widget _buildAnimatedDestination(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: widget.selectedIndex == index ? 1.1 : 1.0),
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: _destinations[index],
        );
      },
    );
  }
}