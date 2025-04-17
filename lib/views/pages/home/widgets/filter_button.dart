// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/providers/steps_notifier.dart';
import 'package:workout_tracker/views/widgets/custom_drop_down_button.dart';

class FilterButton extends ConsumerStatefulWidget {
  const FilterButton({super.key});

  @override
  ConsumerState<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends ConsumerState<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 40,
          width: 100,
          child: CustomDropdownButton(
            items: ['Daily', 'Weekly', 'Monthly'], 
            hint: ref.watch(stepsProvider.notifier).selectedRange, 
            onChanged: (value) {
              setState(() {
                ref.watch(stepsProvider.notifier).setSelectedRange(value!);
                });
            },
          ),
        ),
      ],
    );
  }
}