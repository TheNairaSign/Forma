import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Statistics',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Bar chart
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: const BarChartWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for the bars
    final List<double> barData = [
      0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.15, 0.1, 0.1,  // Morning (6AM-12PM)
      0.3, 0.5, 0.7, 0.4, 0.6, 0.8, 0.4,             // Afternoon (12PM-6PM)
      0.6, 0.5, 0.3, 0.2, 0.1                        // Evening (6PM+)
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Bar chart
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                barData.length,
                (index) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Container(
                      height: barData[index] * 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9642), // Orange color for bars
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Reference line
          Container(
            height: 1,
            color: Colors.grey[300],
          ),
          
          const SizedBox(height: 16),
          
          // Time indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.wb_sunny_outlined, size: 16, color: Colors.grey[400]),
                  const SizedBox(width: 4),
                  Text(
                    '6AM',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              Text(
                '12PM',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
              Text(
                '6PM',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
              Icon(Icons.nightlight_round, size: 16, color: Colors.grey[400]),
            ],
          ),
        ],
      ),
    );
  }
}