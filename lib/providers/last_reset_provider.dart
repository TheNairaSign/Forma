import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _lastResetKey = 'last_daily_reset';

class LastResetNotifier extends StateNotifier<DateTime?> {
  LastResetNotifier() : super(null) {
    _loadLastReset();
  }

  Future<void> _loadLastReset() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastResetKey);
    if (timestamp != null) {
      state = DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
  }

  Future<void> updateResetTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastResetKey, time.millisecondsSinceEpoch);
    state = time;
  }
}

final lastResetProvider = StateNotifierProvider<LastResetNotifier, DateTime?>((ref) {
  return LastResetNotifier();
});