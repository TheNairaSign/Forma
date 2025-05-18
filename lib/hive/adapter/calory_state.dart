import 'package:hive/hive.dart';

part 'calory_state.g.dart';

@HiveType(typeId: 2)
class CaloryState extends HiveObject {
  @HiveField(0)
  double calories;

  @HiveField(1)
  DateTime timestamp;

  CaloryState({required this.calories, required this.timestamp});

  CaloryState copyWith({
    double? calories,
    DateTime? timestamp,
  }) {
    return CaloryState(
      calories: calories ?? this.calories,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
