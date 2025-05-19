import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.controller, this.labelText, required this.hintText, this.keyboardType = TextInputType.text, this.validator, this.fillColor = const Color(0xffeeeef0)});
  final TextEditingController controller;
  final String? labelText;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Color fillColor;

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
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          filled: true,
          fillColor: fillColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none
          ),
          focusColor: Colors.white,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1)
          ),
        ),
        keyboardType: keyboardType,
        validator: validator
      ),
    );
  }
}