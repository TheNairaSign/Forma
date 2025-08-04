// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker/hive/daily_steps_adapter.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/views/widgets/custom_drop_down_button.dart';

class ChartDataContainer extends ConsumerStatefulWidget {
  const ChartDataContainer({super.key});

  @override
  ConsumerState<ChartDataContainer> createState() => _ChartDataContainerState();
}

class _ChartDataContainerState extends ConsumerState<ChartDataContainer> {

  String selectedRange = 'Daily';
  late StepsNotifier stepsState;

  @override
  void initState() {
    super.initState();
    stepsState = ref.read(stepsProvider.notifier);
    stepsState.calculateHourlyStepsForToday();
  }

  List<DailySteps> get currentData {
    switch (selectedRange) {
      case 'Weekly': return stepsState.getWeeklySteps();
      case 'Monthly': return stepsState.getMonthlySteps();
      default: return stepsState.getDailySteps();
    }
  }

  bool isAm = true;

  @override
  Widget build(BuildContext context) {
    final dailyTargetSteps = ref.watch(stepsProvider.notifier).dailyTargetSteps.toDouble();
    final backgroundColor = Color(0xff080b10);

    return SliverAppBar(
      expandedHeight: 350,
      floating: false,
      pinned: true,
      foregroundColor: Colors.white,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          margin: const EdgeInsets.fromLTRB(0, kToolbarHeight + 25 , 0, 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: backgroundColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(text: TextSpan(
                children: [
                  TextSpan(
                    text: 'You have walked',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)
                  ),
                  TextSpan(
                    text: ' ${ref.watch(stepsProvider).steps}\n',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Color(0xff6f64df))
                  ),
                  TextSpan(
                    text: 'steps today',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)
                  ),
                ]
              )),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.directions_walk, color: Colors.green[300], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Steps',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    NumberFormat.compact().format(ref.watch(stepsProvider).steps),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${(ref.watch(stepsProvider).steps / dailyTargetSteps * 100).toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 30,
                    width: 100,
                    child: CustomDropdownButton(
                      backgroundColor: backgroundColor,
                      textColor: Colors.white,
                      borderColor: Colors.white,
                      items: ['Daily', 'Weekly', 'Monthly'],
                      hint: selectedRange, onChanged: (value) {
                        setState(() {
                          selectedRange = value!;
                        });
                    }),
                  ),
                  if (selectedRange == 'Daily')
                  SizedBox(
                    width: 100,
                    child: CupertinoSegmentedControl<bool>(
                      children: <bool, Widget>{
                        true: Text('AM', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
                        false: Text('PM', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
                      },
                      groupValue: isAm,
                      onValueChanged: (bool value) {
                        setState(() {
                          isAm = value;
                        });
                      },
                      selectedColor: Color(0xff6f64df),
                      unselectedColor: backgroundColor,
                      borderColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 100,
                child: BarChart(
                  BarChartData(
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) => Colors.white,
                        tooltipRoundedRadius: 15,
                        tooltipBorder: BorderSide(color: GlobalColors.borderColor, width: .2),
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${rod.toY.toInt()} steps',
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
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
                              // Determine the actual hour based on isAm and index
                              int displayHour;
                              String period;

                              if (isAm) { // AM hours (0-11 for data, 12 AM, 1-11 AM for display)
                                displayHour = (index == 0) ? 12 : index; // 0 maps to 12 AM, 1 to 1 AM, etc.
                                period = "AM";
                              } else { // PM hours (0-11 for data, 12 PM, 1-11 PM for display)
                                displayHour = (index == 0) ? 12 : index; // 0 maps to 12 PM, 1 to 1 PM, etc.
                                period = "PM";
                              }

                              // Always show the label for each hour in the 12-hour slot
                              return Text(
                                '$displayHour$period',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              );
                            }

                            final data = selectedRange == 'Daily'
                              ? ref.watch(stepsProvider).hourlySteps
                              : currentData;
                            if (selectedRange != 'Daily' && data is List<DailySteps> && index < data.length) {
                              final date = data[index].date;
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
                    ? List.generate(
                      12, // Always 12 bars for AM or PM
                      (index) {
                        // Use the backward compatibility method
                        final stepsState = ref.watch(stepsProvider);
                        
                        // Calculate the actual 24-hour key based on isAm
                        final int hourKey = isAm ? index : index + 12;
                        
                        // Use the operator overload or stepsForHour method
                        final steps = stepsState[hourKey]; // or stepsState.stepsForHour(hourKey)

                        return BarChartGroupData(
                          x: index, // Represents 0-11 for the current period (AM/PM)
                          barRods: [
                            BarChartRodData(
                              toY: steps.toDouble(),
                              width: 8,
                              color: steps > 0
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.withOpacity(0.2),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(3),
                                topRight: Radius.circular(3),
                              ),
                            ),
                          ],
                        );
                      },
                    )
                    : List.generate(
                      currentData.length,
                      (index) {
                        final steps = currentData[index].steps;
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: steps.toDouble(),
                              width: 12,
                              color: steps > 0
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.withOpacity(0.2),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(3),
                                topRight: Radius.circular(3),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}