import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:workout_tracker/background_task_handler.dart';
import 'package:workout_tracker/hive/daily_steps_adapter.dart';
// import 'package:workout_tracker/views/pages/auth/login_page.dart.dart';
import 'package:workout_tracker/style/theme/light_theme.dart';
import 'package:workout_tracker/views/pages/navigation/navigation_page.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await initHive();
  
  await AndroidAlarmManager.initialize();
  await AndroidAlarmManager.periodic(
    const Duration(minutes: 15), // adjust interval as needed
    0, // unique id
    backgroundTaskCallback,
    exact: true,
    wakeup: true,
  );
  runApp(ProviderScope(child: WorkoutTracker()));
}


  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(DailyStepsAdapter());
    await Hive.openBox<DailySteps>('dailyStepsBox');
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