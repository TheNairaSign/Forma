import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider;
import 'package:hive_flutter/adapters.dart';
import 'package:workout_tracker/background_task_handler.dart';
import 'package:workout_tracker/hive/daily_steps_adapter.dart';
import 'package:workout_tracker/hive/adapter/calory_state.dart';
import 'package:workout_tracker/models/state/profile_data.dart';
import 'package:workout_tracker/style/theme/light_theme.dart';
import 'package:workout_tracker/providers/workout_group_notifier.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/views/pages/auth/auth_page.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await initHive();

  await AndroidAlarmManager.initialize();
  await AndroidAlarmManager.periodic(
    const Duration(minutes: 15),
    0, // unique id
    backgroundTaskCallback,
    exact: true,
    wakeup: true,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutGroupNotifier()),
      ],
      child: ProviderScope(child: WorkoutTracker()),
    ),
  );
}

  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(DailyStepsAdapter());
    Hive.registerAdapter(CaloryStateAdapter());
    Hive.registerAdapter(ProfileDataAdapter());
    await Hive.openBox<DailySteps>('dailyStepsBox');
    await Hive.openBox<CaloryState>('calorieBox');
    await Hive.deleteBoxFromDisk('caloriesBox');
  }

class WorkoutTracker extends StatelessWidget {
  const WorkoutTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: lightTheme,
    );
  }
}