import 'dart:io';
import 'package:hive/hive.dart';

part '../../hive/adapter/profile_data.g.dart';

@HiveType(typeId: 3)
class ProfileData extends HiveObject {
  @HiveField(0)
  final String? name;
  
  @HiveField(1)
  final String? bio;
  
  @HiveField(2)
  final String? fitnessLevel;
  
  @HiveField(3)
  final String? location;
  
  @HiveField(4)
  final String? profileImagePath;

  @HiveField(5)
  final int? currentStreak;

  @HiveField(6)
  final int? longestStreak;

  @HiveField(7)
  final DateTime? lastWorkoutDate;

  @HiveField(8)
  final String? coverImagePath;

  @HiveField(9)
  final String? gender;

  @HiveField(10)
  final String? birthDate;

  @HiveField(11)
  final double? height;

  @HiveField(12)
  final double? weight;

  @HiveField(14)
  final String? weightGoal;

  @HiveField(15)
  final String? activityLevel;

  @HiveField(13)
  final List<String>? foodPreference;

  @HiveField(16)
  final String? id;

  ProfileData({
    this.id,
    this.name,
    this.bio,
    this.fitnessLevel,
    this.location,
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
    this.foodPreference,
  });

  ProfileData copyWith({
    String? id,
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
    double? height,
    double? weight,
    String? weightGoal,
    String? activityLevel,
    List<String>? foodPreference,
  }) {
    return ProfileData(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      location: location ?? this.location,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      currentStreak: currentStreak ?? this.currentStreak ?? 0,
      longestStreak: longestStreak ?? this.longestStreak ?? 0,
      lastWorkoutDate: lastWorkoutDate ?? this.lastWorkoutDate,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      weightGoal: weightGoal ?? this.weightGoal,
      activityLevel: activityLevel ?? this.activityLevel,
      foodPreference: foodPreference ?? this.foodPreference,
    );
  }

  @override
  String toString() {
    return 'ProfileData(id: $id, name: $name, bio: $bio, fitnessLevel: $fitnessLevel, '
      'location: $location, profileImagePath: $profileImagePath, coverImagePath: $coverImagePath, '
      'currentStreak: $currentStreak, longestStreak: $longestStreak, '
      'lastWorkoutDate: $lastWorkoutDate, gender: $gender, birthDate: $birthDate, '
      'height: $height, weight: $weight, weightGoal: $weightGoal, '
      'activityLevel: $activityLevel, foodPreference: $foodPreference)';
  }

  File? get profileImage => profileImagePath != null ? File(profileImagePath!) : null;
  File? get coverImage => coverImagePath != null ? File(coverImagePath!) : null;
}
