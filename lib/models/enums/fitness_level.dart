enum Level {
  personal,
  professional,
}
/// Enum for personal fitness levels or identities
enum FitnessLevel {
  beginner,
  trainee,
  intermediate,
  advanced,
  fitnessEnthusiast,
  bodybuilder,
  athlete,
  gymRat,
  cardioLover,
  strengthTrainer,
  powerlifter,
  weightlifter,
  crossFitter,
  yogi,
  calisthenicsAthlete,
  mobilityTrainer,
  hiitPractitioner,
}

/// Enum for professional fitness roles or specializations
enum FitnessRole {
  fitnessCoach,
  personalTrainer,
  groupInstructor,
  yogaInstructor,
  strengthCoach,
  wellnessCoach,
  calisthenicsCoach,
  rehabilitationTrainer,
  onlineFitnessCoach,
  sportsCoach,
}

extension FitnessLevelExtension on FitnessLevel {
  String get label {
    switch (this) {
      case FitnessLevel.beginner: return 'Beginner';
      case FitnessLevel.trainee: return 'Trainee';
      case FitnessLevel.intermediate: return 'Intermediate';
      case FitnessLevel.advanced: return 'Advanced';
      case FitnessLevel.fitnessEnthusiast: return 'Fitness Enthusiast';
      case FitnessLevel.bodybuilder: return 'Bodybuilder';
      case FitnessLevel.athlete: return 'Athlete';
      case FitnessLevel.gymRat: return 'Gym Rat';
      case FitnessLevel.cardioLover: return 'Cardio Lover';
      case FitnessLevel.strengthTrainer: return 'Strength Trainer';
      case FitnessLevel.powerlifter: return 'Powerlifter';
      case FitnessLevel.weightlifter: return 'Weightlifter';
      case FitnessLevel.crossFitter: return 'CrossFitter';
      case FitnessLevel.yogi: return 'Yogi';
      case FitnessLevel.calisthenicsAthlete: return 'Calisthenics Athlete';
      case FitnessLevel.mobilityTrainer: return 'Mobility Trainer';
      case FitnessLevel.hiitPractitioner: return 'HIIT Practitioner';
    }
  }
}

extension FitnessRoleExtension on FitnessRole {
  String get label {
    switch (this) {
      case FitnessRole.fitnessCoach: return 'Fitness Coach';
      case FitnessRole.personalTrainer: return 'Personal Trainer';
      case FitnessRole.groupInstructor: return 'Group Instructor';
      case FitnessRole.yogaInstructor: return 'Yoga Instructor';
      case FitnessRole.strengthCoach: return 'Strength Coach';
      case FitnessRole.wellnessCoach: return 'Wellness Coach';
      case FitnessRole.calisthenicsCoach: return 'Calisthenics Coach';
      case FitnessRole.rehabilitationTrainer: return 'Rehabilitation Trainer';
      case FitnessRole.onlineFitnessCoach: return 'Online Fitness Coach';
      case FitnessRole.sportsCoach: return 'Sports Coach';
    }
  }
}

