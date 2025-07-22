// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutGroupAdapter extends TypeAdapter<WorkoutGroup> {
  @override
  final int typeId = 6;

  @override
  WorkoutGroup read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WorkoutGroup.repetition;
      case 1:
        return WorkoutGroup.time;
      case 2:
        return WorkoutGroup.flow;
      case 3:
        return WorkoutGroup.strength;
      case 4:
        return WorkoutGroup.cardio;
      default:
        return WorkoutGroup.repetition;
    }
  }

  @override
  void write(BinaryWriter writer, WorkoutGroup obj) {
    switch (obj) {
      case WorkoutGroup.repetition:
        writer.writeByte(0);
        break;
      case WorkoutGroup.time:
        writer.writeByte(1);
        break;
      case WorkoutGroup.flow:
        writer.writeByte(2);
        break;
      case WorkoutGroup.strength:
        writer.writeByte(3);
        break;
      case WorkoutGroup.cardio:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
