// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({super.key, required this.hintText, required this.svgAsset, required this.controller});
  final TextEditingController controller;
  final String hintText, svgAsset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextField(
        cursorColor: Colors.black,
        controller: controller,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(4, 5, 0, 5),
          prefixIcon: Container(
            padding: EdgeInsets.all(5),
            width: 7,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Color(0xffd8d8d8),
              borderRadius: BorderRadius.circular(20)
            ),
            child: SvgPicture.asset('assets/svgs/$svgAsset.svg', color: Colors.black),
          ),
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
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