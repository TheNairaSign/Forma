
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workout_tracker/hive/adapter/calory_state.dart';
import 'package:workout_tracker/hive/daily_steps_adapter.dart';
import 'package:workout_tracker/hive/step_entry.dart';
import 'package:workout_tracker/models/state/profile_data.dart';
import 'package:workout_tracker/models/workout/custom_color_adapter.dart';
import 'package:workout_tracker/models/workout/workout.dart';
import 'package:workout_tracker/models/workout/workout_session.dart';
import 'package:workout_tracker/models/enums/workout_group.dart';

class HiveService {
  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(DailyStepsAdapter());
    Hive.registerAdapter(CaloryStateAdapter());
    Hive.registerAdapter(ProfileDataAdapter());
    Hive.registerAdapter(WorkoutAdapter());
    Hive.registerAdapter(WorkoutSessionAdapter());
    Hive.registerAdapter(WorkoutGroupAdapter());
    Hive.registerAdapter(CustomColorAdapter());
    Hive.registerAdapter(StepEntryAdapter());

    await openUserBoxes();
  }

  static Future<void> openUserBoxes() async {
    await Hive.openBox<ProfileData>('newUser');
    await Hive.openBox<DailySteps>('dailySteps');
    await Hive.openBox<CaloryState>('calorieBox_');
    await Hive.openBox<Workout>('workouts_');
    await Hive.openBox<Workout>('workout_history_');
    await Hive.openBox<StepEntry>('step_deltas');
  }
}
