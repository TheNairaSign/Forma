import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/providers/calories_provider.dart';
import 'package:workout_tracker/providers/workout_item_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/utils/formatters/format_date.dart';
import 'package:workout_tracker/utils/formatters/format_day.dart';
import 'package:workout_tracker/utils/get_week_days.dart';

class DailyBreakdown extends ConsumerStatefulWidget {
  const DailyBreakdown({super.key, required this.calorieData});
  final List<int> calorieData;

  @override
  ConsumerState<DailyBreakdown> createState() => _DailyBreakdownState();
}

class _DailyBreakdownState extends ConsumerState<DailyBreakdown> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final weekDays = getWeekDays();

    return SliverList.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: weekDays.length,
      itemBuilder: (context, index){
          final day = weekDays[index];
          final isToday = day.day == DateTime.now().day && 
                        day.month == DateTime.now().month && 
                        day.year == DateTime.now().year;
          final caloryForDay = ref.watch(caloryProvider.notifier).getCalorieForDay(day);

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: isToday 
                ? GlobalColors.teal
                : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: GlobalColors.boxShadow(context)
            ),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isToday 
                      ? Colors.black
                      : Color(0xff245501),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  formatDay(day, short: true),
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              // const SizedBox(width: 16),
              title: Text(
                formatDate(day),
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
              ),
              // const SizedBox(height: 2),
              subtitle: Text(
                ref.watch(workoutItemProvider.notifier).workoutForDay[index].name,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              trailing: Text('$caloryForDay kcal', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
            )
          );
        }
    );
  }
}