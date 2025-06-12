
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

  @HiveField(9)
  final String? gender;

  @HiveField(10)
  final String? birthDate;

  @HiveField(11)
  final String? height;

  @HiveField(12)
  final String? weight;

  @HiveField(14)
  final String? weightGoal;

  @HiveField(15)
  final String? activityLevel;

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
    this.gender,
    this.birthDate,
    this.height,
    this.weight,
    this.weightGoal,
    this.activityLevel,
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
    String? gender,
    String? birthDate,
    String? height,
    String? weight,
    String? weightGoal,
    String? activityLevel,
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
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      weightGoal: weightGoal ?? this.weightGoal,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }

  File? get profileImage => profileImagePath != null ? File(profileImagePath!) : null;
  File? get coverImage => coverImagePath != null ? File(coverImagePath!) : null;
}
