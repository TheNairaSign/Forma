// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../daily_steps_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyStepsAdapter extends TypeAdapter<DailySteps> {
  @override
  final int typeId = 1;

  @override
  DailySteps read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailySteps(
      date: fields[0],
      steps: fields[1] as int,
      lastUpdated: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DailySteps obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.steps)
      ..writeByte(2)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyStepsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
