// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutAdapter extends TypeAdapter<Workout> {
  @override
  final int typeId = 4;

  @override
  Workout read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Workout(
      name: fields[1] as String,
      sets: fields[2] as int?,
      timeBasedSets: fields[15] as int?,
      reps: fields[3] as int?,
      weight: fields[4] as double?,
      heartRate: fields[17] as int?,
      restTime: fields[16] as int?,
      distance: fields[5] as int?,
      durationInSeconds: fields[6] as int,
      isActive: fields[7] as bool,
      description: fields[8] as String?,
      sessions: (fields[9] as List).cast<WorkoutSession>(),
      goalReps: fields[10] as int?,
      goalDuration: fields[11] as int?,
      intensity: fields[13] as String?,
      workoutGroup: fields[12] as WorkoutGroup?,
      workoutColor: fields[14] as Color?,
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, Workout obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.sets)
      ..writeByte(3)
      ..write(obj.reps)
      ..writeByte(4)
      ..write(obj.weight)
      ..writeByte(5)
      ..write(obj.distance)
      ..writeByte(15)
      ..write(obj.timeBasedSets)
      ..writeByte(16)
      ..write(obj.restTime)
      ..writeByte(6)
      ..write(obj.durationInSeconds)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.sessions)
      ..writeByte(10)
      ..write(obj.goalReps)
      ..writeByte(11)
      ..write(obj.goalDuration)
      ..writeByte(17)
      ..write(obj.heartRate)
      ..writeByte(12)
      ..write(obj.workoutGroup)
      ..writeByte(13)
      ..write(obj.intensity)
      ..writeByte(14)
      ..write(obj.workoutColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
