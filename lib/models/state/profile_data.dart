
import 'dart:io';
import 'package:hive/hive.dart';

part '../../hive/adapter/profile_data.g.dart';

@HiveType(typeId: 3)
class ProfileData extends HiveObject {
  @HiveField(0)
  final String name;
  
  @HiveField(1)
  final String bio;
  
  @HiveField(2)
  final String? fitnessLevel;
  
  @HiveField(3)
  final String? location;
  
  @HiveField(4)
  final String? profileImagePath;

  @HiveField(5)
  final int currentStreak;

  @HiveField(6)
  final int longestStreak;

  @HiveField(7)
  final DateTime? lastWorkoutDate;

  @HiveField(8)
  final String? coverImagePath;

  ProfileData({
    required this.name,
    required this.bio,
    required this.fitnessLevel,
    required this.location,
    this.profileImagePath,
    this.coverImagePath,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastWorkoutDate,
  });

  ProfileData copyWith({
    String? name,
    String? bio,
    String? fitnessLevel,
    String? location,
    String? profileImagePath,
    String? coverImagePath,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastWorkoutDate,
  }) {
    return ProfileData(
      name: name ?? this.name,
      bio: bio ?? this.bio,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      location: location ?? this.location,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastWorkoutDate: lastWorkoutDate ?? this.lastWorkoutDate,
    );
  }

  File? get profileImage => profileImagePath != null ? File(profileImagePath!) : null;
  File? get coverImage => coverImagePath != null ? File(coverImagePath!) : null;
}
