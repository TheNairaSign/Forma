
// ignore_for_file: avoid_print

import 'package:hive/hive.dart';
import 'package:workout_tracker/hive/adapter/calory_state.dart';
import 'package:workout_tracker/hive/daily_steps_adapter.dart';

class UserBoxService {
  final String? userId;

  UserBoxService(this.userId);

  // Future<Box> getWorkoutBox() async => await Hive.openBox('workoutBox_$u
  Future<Box> getStepsBox() async {
    print('Opening steps box... with id: $userId');
    final stepsBox = await Hive.openBox<DailySteps>('stepsBox_$userId');
    print('Steps box is Opened: ${stepsBox.isOpen} With name: ${stepsBox.name}');
    // Hive.registerAdapter(DailyStepsAdapter());
    return stepsBox;
  }

  Future<Box> getCaloriesBox() async {
    print('Opening calories box... with id: $userId');
    final calBox = await Hive.openBox<CaloryState>('calorieBox_$userId');

    print('Calorie box is opened: ${calBox.isOpen} With name: ${calBox.name}');
    return calBox;
  }

  /*
  Box<DailySteps> get dailyStepsBox {
    final stepsBox = Hive.box<DailySteps>('stepsBox_$userId');
    print('Getting steps box: ${stepsBox.isOpen}, ${stepsBox.name}');

    return stepsBox;
  }

  Box<CaloryState> get calorieBox {
    final _caloryBox = Hive.box<CaloryState>('calorieBox_$userId');
    print('Getting calorie box: ${_caloryBox.isOpen}, ${_caloryBox.name}');
    return _caloryBox;
  }
  */
  
}
