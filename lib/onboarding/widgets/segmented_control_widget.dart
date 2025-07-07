// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/style/global_colors.dart';

class CustomSegmentedControl extends StatefulWidget {
  CustomSegmentedControl({
    super.key,
    required this.option1,
    required this.option2,
    required this.selected,
    required this.onChanged,
  });

  final String option1;
  final String option2;
  bool selected;
  final ValueChanged<bool> onChanged;

  @override
  State<CustomSegmentedControl> createState() => _CustomSegmentedControlState();
}

class _CustomSegmentedControlState extends State<CustomSegmentedControl> {
  @override
  Widget build(BuildContext context) {

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: CupertinoSegmentedControl<bool>(
          children: {
            true: Center(child: Text(widget.option1, style: Theme.of(context).textTheme.bodyLarge)),
            false: Center(child: Text(widget.option2, style: Theme.of(context).textTheme.bodyLarge)),
          },
          groupValue: widget.selected,
          onValueChanged: (val) {
            setState(() {
              widget.selected = val;
              widget.onChanged(val);
            });
          },
          selectedColor: GlobalColors.primaryColorLight,
          unselectedColor: Colors.white,
          borderColor: const Color.fromARGB(45, 158, 158, 158),
          padding: EdgeInsets.zero,
          // pressedColor: Colors.deepPurple.withOpacity(0.2),
        ),
      ),
    );
  }
}

