// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:workout_tracker/style/global_colors.dart';

class AuthTextField extends StatefulWidget {
  AuthTextField({
    super.key, 
    required this.hintText, 
    required this.svgAsset, 
    required this.controller,
    this.showSuffix = false,
    this.obscure = false,
  });
  final TextEditingController controller;
  final String hintText, svgAsset;
  final bool showSuffix; 
  bool obscure;
  
  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextField(
        cursorColor: Colors.black,
        controller: widget.controller,
        obscureText: widget.obscure,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(4, 5, 0, 5),
          prefixIcon: Container(
            padding: EdgeInsets.all(5),
            width: 7,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              // color: Color(0xffd8d8d8),
              color: GlobalColors.primaryColorLight,
              borderRadius: BorderRadius.circular(20)
            ),
            child: SvgPicture.asset('assets/svgs/${widget.svgAsset}.svg', color: GlobalColors.primaryColor),
          ),
          hintText: widget.hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: (widget.showSuffix ? GestureDetector(
          onTap: () {
            setState(() {
              widget.obscure = !widget.obscure;
            });
          },
        child: Icon(widget.obscure? Icons.visibility_off : Icons.visibility, color: GlobalColors.textThemeColor(context), size: 20)) : null),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.black, width: .5),
          )
        ),
      ),
    );
  }
}