import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:workout_tracker/views/pages/auth/login_page.dart.dart';
import 'package:workout_tracker/style/theme/light_theme.dart';
import 'package:workout_tracker/views/pages/navigation/navigation_page.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ProviderScope(child: WorkoutTracker()));
}

class WorkoutTracker extends StatelessWidget {
  const WorkoutTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NavigationPage(),
      theme: lightTheme,
    );
  }
}