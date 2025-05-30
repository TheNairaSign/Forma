import 'enums/exercise_type.dart';
import 'enums/workout_type.dart';

class WorkoutExerciseMapping {
  static Map<WorkoutType, List<ExerciseType>> exercisesByWorkoutType = {
    WorkoutType.fullBody: [
      ExerciseType.burpees,
      ExerciseType.mountainClimbers,
      ExerciseType.jumpingJacks,
      ExerciseType.turkishGetUps,
    ],
    
    WorkoutType.chest: [
      ExerciseType.benchPress,
      ExerciseType.pushUps,
      ExerciseType.dumbellFlyes,
      ExerciseType.cableCrossover,
    ],
    
    WorkoutType.back: [
      ExerciseType.pullUps,
      ExerciseType.latPulldowns,
      ExerciseType.bentOverRows,
      ExerciseType.deadlifts,
    ],
    
    WorkoutType.shoulders: [
      ExerciseType.militaryPress,
      ExerciseType.lateralRaises,
      ExerciseType.frontRaises,
      ExerciseType.facePulls,
    ],
    
    WorkoutType.legs: [
      ExerciseType.squats,
      ExerciseType.lunges,
      ExerciseType.legPress,
      ExerciseType.calfRaises,
    ],
    
    WorkoutType.arms: [
      ExerciseType.bicepCurls,
      ExerciseType.tricepExtensions,
      ExerciseType.hammerCurls,
      ExerciseType.diamondPushUps,
    ],
    
    WorkoutType.core: [
      ExerciseType.planks,
      ExerciseType.crunches,
      ExerciseType.russianTwists,
      ExerciseType.legRaises,
    ],
    
    WorkoutType.cardio: [
      ExerciseType.running,
      ExerciseType.cycling,
      ExerciseType.swimming,
      ExerciseType.jumpRope,
    ],
    
    WorkoutType.hiit: [
      ExerciseType.boxJumps,
      ExerciseType.speedBurpees,
      ExerciseType.highKnees,
      ExerciseType.mountainClimberSprints,
    ],
    
    WorkoutType.pushDay: [
      ExerciseType.inclineBenchPress,
      ExerciseType.shoulderPress,
      ExerciseType.tricepDips,
      ExerciseType.lateralRaises,
    ],
    
    WorkoutType.pullDay: [
      ExerciseType.chinUps,
      ExerciseType.barbellRows,
      ExerciseType.facePulls,
      ExerciseType.bicepCurls,
    ],
    
    WorkoutType.upperBody: [
      ExerciseType.dips,
      ExerciseType.pushUps,
      ExerciseType.pullUps,
      ExerciseType.overheadPress,
    ],
    
    WorkoutType.lowerBody: [
      ExerciseType.romanianDeadlifts,
      ExerciseType.bulgarianSplitSquats,
      ExerciseType.hipThrusts,
      ExerciseType.legExtensions,
    ],
    
    WorkoutType.yoga: [
      ExerciseType.downwardDog,
      ExerciseType.warriorPose,
      ExerciseType.treePose,
      ExerciseType.childsPose,
    ],
    
    WorkoutType.mobility: [
      ExerciseType.hipOpeners,
      ExerciseType.shoulderDislocates,
      ExerciseType.ankleMobility,
      ExerciseType.thoracicBridge,
    ],
    
    WorkoutType.strength: [
      ExerciseType.powerCleans,
      ExerciseType.frontSquats,
      ExerciseType.overheadPress,
      ExerciseType.romanianDeadlifts,
    ],
    
    WorkoutType.endurance: [
      ExerciseType.walkingLunges,
      ExerciseType.bodyweightSquats,
      ExerciseType.pushUpHolds,
      ExerciseType.wallSit,
    ],
    
    WorkoutType.balance: [
      ExerciseType.singleLegStand,
      ExerciseType.bosuBallSquats,
      ExerciseType.yogaBalance,
      ExerciseType.stabilityBallPlanks,
    ],
    
    WorkoutType.flexibility: [
      ExerciseType.hamstringStretch,
      ExerciseType.butterflyStretch,
      ExerciseType.quadStretch,
      ExerciseType.calfStretch,
    ],
    
    WorkoutType.warmUp: [
      ExerciseType.armCircles,
      ExerciseType.legSwings,
      ExerciseType.jumpingJacks,
      ExerciseType.joggingInPlace,
    ],
    
    WorkoutType.coolDown: [
      ExerciseType.walkingInPlace,
      ExerciseType.lightStretching,
      ExerciseType.deepBreathing,
      ExerciseType.gentleTwists,
    ],
  };
}