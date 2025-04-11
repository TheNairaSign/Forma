// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:workout_tracker/style/global_colors.dart';

class CustomDropdownButton extends StatefulWidget {
  final List items;
  String? initialValue;
  final String hint;
  final void Function(String?)? onChanged;
  final double width;
  final Color textColor;

  CustomDropdownButton({
    super.key,
    required this.items,
    this.initialValue,
    required this.hint,
    this.onChanged,
    this.width = double.infinity,
    this.textColor = Colors.black87,
  });

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GlobalColors.borderColor, width: .5),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            hint: Text(widget.hint, style: Theme.of(context).textTheme.bodyMedium?.copyWith()),
            value: widget.initialValue,
            dropdownColor: Colors.white,
            isExpanded: true,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: GlobalColors.textThemeColor(context)),
            onChanged: (String? newValue) {
              setState(() {
                widget.initialValue = newValue;
                if (widget.onChanged != null) {
                  widget.onChanged!(newValue);
                }
              });
            },
            items: widget.items.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: GlobalColors.textThemeColor(context)),),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}