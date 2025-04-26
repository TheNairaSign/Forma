class EditProfileState {
  EditProfileState({
    required this.currentName,
    required this.currentBio,
    required this.currentLocation,
    required this.currentGoal,
    required this.currentFitnessLevel,
    required this.currentAvatarPath,
  });

  final String currentName;
  final String currentBio;
  final String currentLocation;
  final String currentGoal;
  final String currentFitnessLevel;
  final String currentAvatarPath;

  EditProfileState copyWith({
    String? currentName,
    String? currentBio,
    String? currentLocation,
    String? currentGoal,
    String? currentFitnessLevel,
    String? currentAvatarPath,
  }) {
    return EditProfileState(
      currentName: currentName ?? this.currentName,
      currentBio: currentBio ?? this.currentBio,
      currentLocation: currentLocation ?? this.currentLocation,
      currentGoal: currentGoal ?? this.currentGoal,
      currentFitnessLevel: currentFitnessLevel ?? this.currentFitnessLevel,
      currentAvatarPath: currentAvatarPath ?? this.currentAvatarPath,
    );
  }
}
