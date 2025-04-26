// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  final List items;
  String? initialValue;
  final String hint;
  final void Function(String?)? onChanged;
  final double width;
  final Color textColor;
  final Color? backgroundColor, borderColor;

  CustomDropdownButton({
    super.key,
    required this.items,
    this.initialValue,
    required this.hint,
    this.onChanged,
    this.width = double.infinity,
    this.textColor = Colors.black87,
    this.borderColor,
    this.backgroundColor
  });

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  @override
  Widget build(BuildContext context) {
    final color = widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
    return Container(
      width: widget.width,
      height: 45,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: widget.borderColor != null ? Border.all(color: widget.borderColor!, width: .5) : null,
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            hint: Text(widget.hint, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: widget.textColor)),
            value: widget.initialValue,
            dropdownColor: color,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down, color: widget.textColor),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: widget.textColor),
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
                child: Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: widget.textColor),),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}