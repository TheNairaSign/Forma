import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelectionWidget extends StatefulWidget {
  const DateSelectionWidget({super.key});

  @override
  State<DateSelectionWidget> createState() => _DateSelectionWidgetState();
}

class _DateSelectionWidgetState extends State<DateSelectionWidget> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('d MMM yyyy').format(selectedDate),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_down),
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Day selector
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context, index) {
              final day = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1 - index));
              final isSelected = 
                      day.day == selectedDate.day && 
                      day.month == selectedDate.month &&
                      day.year == selectedDate.year;
    
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = day;
                  });
                },
                child: Container(
                  width: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xff6f64df) : Colors.transparent,
                    border: !isSelected ? Border.all(color: Colors.green.shade200) : null,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          DateFormat('E').format(day).toUpperCase().substring(0, 3),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                        ),

                      const Spacer(),
                      Container(
                        width: double.infinity,
                        height: 35,
                        decoration: BoxDecoration(
                          color: isSelected? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            day.day.toString(),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Color(0xff6f64df) : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ), 
      ]
    );
  }

}