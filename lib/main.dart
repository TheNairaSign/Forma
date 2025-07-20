import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider;
import 'package:hive_flutter/adapters.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workout_tracker/auth/auth_checker.dart';
import 'package:workout_tracker/background_task_handler.dart';
import 'package:workout_tracker/constants.dart';
import 'package:workout_tracker/hive/daily_steps_adapter.dart';
import 'package:workout_tracker/hive/adapter/calory_state.dart';
import 'package:workout_tracker/models/state/profile_data.dart';
import 'package:workout_tracker/style/theme/light_theme.dart';
import 'package:workout_tracker/providers/workout_group_notifier.dart';
import 'package:provider/provider.dart';


void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await initHive();

  await Supabase.initialize(
    url: projectUrl,
    anonKey: anonKey,
    // debug: true,
  );


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
    // await Hive.openBox<DailySteps>('dailyStepsBox');
    // await Hive.openBox<CaloryState>('calorieBox');
    await Hive.openBox<ProfileData>('newUser');


  }

class WorkoutTracker extends ConsumerStatefulWidget {
  const WorkoutTracker({super.key});

  @override
  ConsumerState<WorkoutTracker> createState() => _WorkoutTrackerState();
}

class _WorkoutTrackerState extends ConsumerState<WorkoutTracker> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthChecker(),
      theme: lightTheme,
    );
  }
}