// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroupForm extends StatelessWidget {
  const GroupForm({
    super.key,
    required this.controller,
    this.inputFormatters,
    required this.labelText,
    this.validator,
    required this.keyboardType, 
    this.hintText, this.maxLines, this.maxLength,
  });
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String labelText; 
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String? value)? validator;
  final int? maxLines, maxLength;

  @override 
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextFormField(
        style: Theme.of(context).textTheme.bodyMedium,
        cursorColor: Colors.black,
        maxLines: maxLines,
        maxLength: maxLength,
        controller: controller,
        inputFormatters: inputFormatters,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          floatingLabelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
          enabled: true,
          labelText: labelText,
          labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          // alignLabelWithHint: true,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey, width: .3)
          ),
          focusColor: Colors.white,
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1)),
        ),
      ),
    );
  }
}
