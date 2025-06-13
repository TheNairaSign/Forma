import 'package:hive/hive.dart';

part 'calory_state.g.dart';

@HiveType(typeId: 2)
class CaloryState extends HiveObject {
  @HiveField(0)
  final int calories;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final String? source;

  CaloryState({
    required this.calories,
    required this.timestamp,
    this.source,
  });

  CaloryState copyWith({
    int? calories,
    DateTime? timestamp,
    String? source,
  }) {
    return CaloryState(
      calories: calories ?? this.calories,
      timestamp: timestamp ?? this.timestamp,
      source: source ?? this.source,
    );
  }
}
