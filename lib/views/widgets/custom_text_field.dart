import 'package:flutter/material.dart';
import 'package:workout_tracker/style/global_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.controller, required this.labelText, required this.hintText, this.keyboardType = TextInputType.text, this.validator});
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextFormField(
        controller: controller,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
        cursorColor: Colors.black,
        decoration: InputDecoration(
          // alignLabelWithHint: true,
          // floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
          enabled: true,
          labelText: labelText,
          labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          alignLabelWithHint: true,
          // hintText: hintText,
          // hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GlobalColors.borderColor, width:.5)
          ),
          focusColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black, width: .5)
          ),
        ),
        keyboardType: keyboardType,
        validator: validator
      ),
    );
  }
}