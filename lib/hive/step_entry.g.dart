// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StepEntryAdapter extends TypeAdapter<StepEntry> {
  @override
  final int typeId = 8;

  @override
  StepEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StepEntry(
      timestamp: fields[0] as DateTime,
      steps: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StepEntry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.steps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StepEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
