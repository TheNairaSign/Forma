import 'dart:convert';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_tracker/models/workout/workout_plan.dart';

class WorkoutPlanService {
  final String _planKey = 'plans';

    Future<void> savePlans(List<WorkoutPlan> plans) async {
    final prefs = await SharedPreferences.getInstance();
    final planMaps = plans.map((p) => p.toMap()).toList();
    final jsonString = jsonEncode(planMaps);
    await prefs.setString(_planKey, jsonString);
  }

  Future<List<WorkoutPlan>> getPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_planKey);
    if (jsonString == null) return [];
    final planMaps = jsonDecode(jsonString) as List;
    return planMaps.map((map) => WorkoutPlan.fromMap(map)).toList();
  }

  Future<void> addPlan(WorkoutPlan plan) async {
    final plans = await getPlans();
    plans.add(plan);
    await savePlans(plans);
  }

  Future<void> updatePlan(WorkoutPlan updatedPlan) async {
    final plans = await getPlans();
    final index = plans.indexWhere((p) => p.name == updatedPlan.name);
    if (index != -1) {
      plans[index] = updatedPlan;
      await savePlans(plans);
    }
  }
}