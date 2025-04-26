// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../models/state/profile_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileDataAdapter extends TypeAdapter<ProfileData> {
  @override
  final int typeId = 3;

  @override
  ProfileData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileData(
      name: fields[0] as String,
      bio: fields[1] as String,
      fitnessLevel: fields[2] as String?,
      location: fields[3] as String?,
      profileImagePath: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.bio)
      ..writeByte(2)
      ..write(obj.fitnessLevel)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.profileImagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
