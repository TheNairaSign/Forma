import 'package:intl/intl.dart';

class ProgressData {
  final String dayOfThWeek;
  final double height;

  ProgressData({required this.dayOfThWeek, required this.height});

  static final List<ProgressData> progressDataList = [
    ProgressData(dayOfThWeek: 'Mon', height: 0.5),
    ProgressData(dayOfThWeek: 'Tue', height: 0.6),
    ProgressData(dayOfThWeek: 'Wed', height: 0.7),
    ProgressData(dayOfThWeek: 'Thu', height: 0.5),
    ProgressData(dayOfThWeek: 'Fri', height: 0.65),
    ProgressData(dayOfThWeek: 'Sat', height: 0.45),
    ProgressData(dayOfThWeek: 'Sun', height: 0.55), 
  ];

  static bool isHighlighted(String dayOfThWeek) {
    final now = DateTime.now();
    final today = DateFormat('EEE').format(now);

    return dayOfThWeek == today;
  }
}