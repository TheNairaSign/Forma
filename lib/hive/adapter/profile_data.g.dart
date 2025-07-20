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
      id: fields[16] as String?,
      name: fields[0] as String?,
      bio: fields[1] as String?,
      fitnessLevel: fields[2] as String?,
      location: fields[3] as String?,
      profileImagePath: fields[4] as String?,
      coverImagePath: fields[8] as String?,
      currentStreak: fields[5] as int?,
      longestStreak: fields[6] as int?,
      lastWorkoutDate: fields[7] as DateTime?,
      gender: fields[9] as String?,
      birthDate: fields[10] as String?,
      height: fields[11] as double?,
      weight: fields[12] as double?,
      weightGoal: fields[14] as String?,
      activityLevel: fields[15] as String?,
      foodPreference: (fields[13] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProfileData obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.bio)
      ..writeByte(2)
      ..write(obj.fitnessLevel)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.profileImagePath)
      ..writeByte(5)
      ..write(obj.currentStreak)
      ..writeByte(6)
      ..write(obj.longestStreak)
      ..writeByte(7)
      ..write(obj.lastWorkoutDate)
      ..writeByte(8)
      ..write(obj.coverImagePath)
      ..writeByte(9)
      ..write(obj.gender)
      ..writeByte(10)
      ..write(obj.birthDate)
      ..writeByte(11)
      ..write(obj.height)
      ..writeByte(12)
      ..write(obj.weight)
      ..writeByte(14)
      ..write(obj.weightGoal)
      ..writeByte(15)
      ..write(obj.activityLevel)
      ..writeByte(13)
      ..write(obj.foodPreference)
      ..writeByte(16)
      ..write(obj.id);
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
