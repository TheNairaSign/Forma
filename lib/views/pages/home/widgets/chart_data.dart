// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker/hive/daily_steps_adapter.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';
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
    // final borderRadius = BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8));
    final dailyTargetSteps = ref.watch(stepsProvider.notifier).dailyTargetSteps.toDouble();
    final backgroundColor = Color(0xff080b10); 

    return SliverAppBar(
      expandedHeight: 350,
      floating: false,
      pinned: true,
      foregroundColor: Colors.white,
      backgroundColor: backgroundColor,
      // toolbarHeight: 400,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          margin: const EdgeInsets.fromLTRB(0, kToolbarHeight + 25 , 0, 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: backgroundColor,
          ),
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
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                    height: 100,
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
                                
                                final data = selectedRange == 'Daily' 
                                  ? stepsState.getHourlySteps() 
                                  : currentData;
                                if (data is List<DailySteps> && index < data.length) {
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
                              24,
                              (index) {
                                final hourlyData = stepsState.getHourlySteps();
                                final steps = hourlyData[index] ?? 0;
                                return BarChartGroupData(
                                  x: index,
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