// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../hourly_steps.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HourlyStepsAdapter extends TypeAdapter<HourlySteps> {
  @override
  final int typeId = 9;

  @override
  HourlySteps read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      final key = reader.readByte();
      final value = reader.read();
      fields[key] = value;
    }
    return HourlySteps(
      timestamp: fields[0] as DateTime,
      hour: fields[1] as int,
      steps: fields[2] as int,
      lastUpdated: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HourlySteps obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.hour)
      ..writeByte(2)
      ..write(obj.steps)
      ..writeByte(3)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HourlyStepsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}