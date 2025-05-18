// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calory_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CaloryStateAdapter extends TypeAdapter<CaloryState> {
  @override
  final int typeId = 2;

  @override
  CaloryState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CaloryState(
      calories: fields[0] as double,
      timestamp: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CaloryState obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.calories)
      ..writeByte(1)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CaloryStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
