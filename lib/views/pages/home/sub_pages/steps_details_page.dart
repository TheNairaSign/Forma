import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker/hive/daily_steps_adapter.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';
import 'package:workout_tracker/views/pages/home/widgets/steps_counter_widget.dart';
import 'package:workout_tracker/views/widgets/animated_page_entry.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:workout_tracker/views/widgets/custom_drop_down_button.dart';

class StepsDetailsPage extends ConsumerStatefulWidget {
  const StepsDetailsPage({super.key, required this.currentSteps});
  final int currentSteps;

  @override
  ConsumerState<StepsDetailsPage> createState() => _StepsDetailsPageState();
}

class _StepsDetailsPageState extends ConsumerState<StepsDetailsPage> {
  String selectedRange = 'Daily';
  late StepsNotifier stepsState;

  @override
  void initState() {
    super.initState();
    stepsState = ref.read(stepsProvider.notifier);
  }

  List<DailySteps> get currentData {
    switch (selectedRange) {
      case 'Weekly': return stepsState.getWeeklySteps();
      case 'Monthly': return stepsState.getMonthlySteps();
      default: return stepsState.getDailySteps();
    }
  }

  @override
  Widget build(BuildContext context) {
  final dailyTargetSteps = ref.watch(stepsProvider.notifier).dailyTargetSteps.toDouble();

    return Scaffold(
      appBar: AppBar(title: Text('Step Counter', style: Theme.of(context).textTheme.headlineSmall,),centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedPageEntry(
          children: [
            StepCounterWidget(caloriesBurned: 870, progressColor: Color(0xFF4CD964)),
            const SizedBox(height: 10),

            // Range Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 40,
                  width: 100,
                  child: CustomDropdownButton(
                    items: ['Daily', 'Weekly', 'Monthly'], 
                    hint: selectedRange, onChanged: (value) {
                      setState(() {
                        selectedRange = value!;
                      });
                  }),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  alignment: BarChartAlignment.spaceAround,
                  maxY: dailyTargetSteps,
                  minY: 0,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    drawHorizontalLine: false,
                    horizontalInterval: 1000,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.15),
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2000,
                        reservedSize: 20,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${(value / 1000).toInt()}k',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (selectedRange == 'Daily') {
                            if ([3, 6, 9, 12, 15, 18, 21].contains(index)) {
                              return Text(
                                '${index > 12 ? index - 12 : index}${index >= 12 ? "PM" : "AM"}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              );
                            }
                            return const Text('');
                          }
                          if (index < currentData.length) {
                            final date = currentData[index].date;
                            return Text(
                              selectedRange == 'Monthly'
                                ? DateFormat('MMM').format(date)
                                : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday % 7],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  barGroups: selectedRange == 'Daily'
                    ? stepsState.getHourlySteps()
                        .entries
                        .map((entry) => BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.toDouble(),
                              color: Colors.green.shade300,
                              width: 12,
                              borderRadius: BorderRadius.circular(6),
                            )
                          ],
                        ))
                        .toList()
                    : currentData
                        .asMap()
                        .entries
                        .map((entry) => BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.steps.toDouble() > dailyTargetSteps ? dailyTargetSteps : entry.value.steps.toDouble(),
                              color: entry.value.date.weekday % 2 == 0 
                                ? Colors.blue.shade300 
                                : Colors.green.shade300,
                              width: 20,
                              borderRadius: BorderRadius.circular(10),
                            )
                          ],
                        ))
                        .toList(),
                ),
              ),
            ),
          ]
        ),
      )
    );
  }
}