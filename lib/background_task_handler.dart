import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pedometer/pedometer.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:workout_tracker/hive/daily_steps_adapter.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';

@pragma('vm:entry-point')
void backgroundTaskCallback() async {
  debugPrint('Background task callback called');
  await _updateStepCountInBackground();
}

@pragma('vm:entry-point')
Future<void> _updateStepCountInBackground() async {
  debugPrint('Background step update started...');
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    await Hive.openBox<DailySteps>('dailySteps');
    // await UserBoxService().getStepsBox();
    Hive.registerAdapter(DailyStepsAdapter());
    
    final container = ProviderContainer(overrides: []);
    final repository = container.read(stepsProvider.notifier);
    final steps = await Pedometer.stepCountStream.first.then((s) => s.steps);
    
    await repository.onStepCount(steps);
    
    debugPrint('Background step update completed: $steps steps');
  } catch (e) {
    debugPrint('Background step update failed: $e');
    // Schedule retry using AlarmManager
    await AndroidAlarmManager.oneShot(
      const Duration(minutes: 5),
      0, // unique id
      backgroundTaskCallback,
      exact: true,
      wakeup: true,
    );
  } finally {
    await Hive.close();
  }
}