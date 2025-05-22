import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/utils/formatters/format_day.dart';
import 'package:workout_tracker/utils/get_week_days.dart';

class WeeklyChartContainer extends StatefulWidget {
  const WeeklyChartContainer({super.key, required this.calorieData, required this.backgroundColor});
  final List<int> calorieData;
  final Color backgroundColor;

  @override
  State<WeeklyChartContainer> createState() => _WeeklyChartContainerState();
}

class _WeeklyChartContainerState extends State<WeeklyChartContainer> {
  int _selectedBarIndex = -1;
  final weekDays = getWeekDays();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Calories Burned',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => Colors.white,
                  tooltipRoundedRadius: 15,
                  tooltipBorder: BorderSide(color: GlobalColors.borderColor, width: .2),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final day = weekDays[groupIndex];
                    return BarTooltipItem(
                      '${formatDay(day)}\n${rod.toY.toInt()} kcal',
                      Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                touchCallback: (event, response) {
                  if (response?.spot != null && event is FlTapUpEvent) {
                    setState(() {
                      _selectedBarIndex = response!.spot!.touchedBarGroupIndex;
                    });
                  }
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < weekDays.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            formatDay(weekDays[index], short: true),
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
                          ),
                        );
                      }
                      return const Text('');
                    },
                    reservedSize: 36,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 500,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              barGroups: _buildBarGroups(widget.calorieData, theme),
              gridData: FlGridData(
                show: false,
                drawVerticalLine: false,
              ),
              alignment: BarChartAlignment.spaceAround,
              maxY: 2500,
            ),
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups(List<int> calorieData, ThemeData theme) {
    return List.generate(calorieData.length, (index) {
      final isSelected = index == _selectedBarIndex;
      final color = isSelected 
          ? GlobalColors.teal
          : GlobalColors.glowGreen;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: calorieData[index].toDouble(),
            color: color,
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: calorieData.isNotEmpty 
                  ? (calorieData.reduce((a, b) => a > b ? a : b).toDouble() * 1.2)
                  : null,
              color: Colors.transparent,
            ),
          ),
        ],
        showingTooltipIndicators: isSelected ? [0] : [],
      );
    });
  }
}