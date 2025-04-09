import 'package:flutter/material.dart';
import 'package:workout_tracker/hive/daily_steps_adapter.dart';
import 'package:workout_tracker/views/pages/home/widgets/steps_counter_widget.dart';
import 'package:workout_tracker/views/widgets/animated_page_entry.dart';
import 'package:fl_chart/fl_chart.dart';

class StepsDetailsPage extends StatefulWidget {
  const StepsDetailsPage({super.key, required this.currentSteps});
  final int currentSteps;

  @override
  State<StepsDetailsPage> createState() => _StepsDetailsPageState();
}

class _StepsDetailsPageState extends State<StepsDetailsPage> {
  String selectedRange = 'Daily';

  List<DailySteps> get currentData {
    switch (selectedRange) {
      case 'Weekly': return weeklySteps;
      case 'Monthly': return monthlySteps;
      default: return dailySteps;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Step Counter', style: Theme.of(context).textTheme.headlineSmall,),centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedPageEntry(children: [
          StepCounterWidget(
          caloriesBurned: 870,
          progressColor: Color(0xFF4CD964),
        ),
        const SizedBox(height: 10),

        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(10),
          ),
          child:AspectRatio(
          aspectRatio: 1.6,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index < currentData.length) {
                        final date = currentData[index].date;
                        return Text(
                          selectedRange == 'Monthly'
                            ? '${date.month}/${date.year.toString().substring(2)}'
                            : selectedRange == 'Weekly'
                              ? 'W${date.weekday}'
                              : '${date.day}/${date.month}',
                          style: TextStyle(fontSize: 10),
                        );
                      }
                      return Text('');
                    },
                  ),
                ),
              ),
              barGroups: currentData
                .asMap()
                .entries
                .map((entry) => BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.steps.toDouble(),
                      color: Colors.blue,
                      width: 16,
                      borderRadius: BorderRadius.circular(6),
                    )
                  ],
                ))
                .toList(),
            ),
          ),
        ),
        )
        ]),
      )
    );
  }
}

List<DailySteps> dailySteps = List.generate(
  7,
  (index) => DailySteps(
    lastUpdated: DateTime.now(),
    date: DateTime.now().subtract(Duration(days: 6 - index)),
    steps: 2000 + index * 1000,
  ),
);

List<DailySteps> weeklySteps = List.generate(
  4,
  (index) => DailySteps(
    lastUpdated: DateTime.now(),
    date: DateTime.now().subtract(Duration(days: 7 * (3 - index))),
    steps: 15000 + index * 3000,
  ),
);

List<DailySteps> monthlySteps = List.generate(
  6,
  (index) => DailySteps(
    lastUpdated: DateTime.now(),
    date: DateTime(DateTime.now().year, DateTime.now().month - (5 - index), 1),
    steps: 60000 + index * 8000,
  ),
);


// class StepsChart extends StatefulWidget {
//   @override
//   _StepsChartState createState() => _StepsChartState();
// }

// class _StepsChartState extends State<StepsChart> {
//   String selectedRange = 'Daily';

//   List<StepData> get currentData {
//     switch (selectedRange) {
//       case 'Weekly': return weeklySteps;
//       case 'Monthly': return monthlySteps;
//       default: return dailySteps;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Range Selector
//         DropdownButton<String>(
//           value: selectedRange,
//           onChanged: (value) {
//             setState(() {
//               selectedRange = value!;
//             });
//           },
//           items: ['Daily', 'Weekly', 'Monthly']
//               .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//               .toList(),
//         ),

//         SizedBox(height: 20),

//         // Chart Display
        
//       ],
//     );
//   }
// }

