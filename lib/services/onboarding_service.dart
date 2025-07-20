  import 'package:shared_preferences/shared_preferences.dart';


class OnboardingService {
  OnboardingService._();
  static final OnboardingService _instance = OnboardingService._();
  static OnboardingService get instance => _instance;

  Future<bool> hasUserCompletedOnboarding(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_$userId') ?? false;
  }

  Future<void> setUserCompletedOnboarding(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_$userId', true);
  }

}