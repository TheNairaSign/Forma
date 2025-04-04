import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OverallStatusModel {
  final Widget icon;
  final String title;
  final String subtitle, gain, progressPercentage;
  final Color? containerColor;

  OverallStatusModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gain,
    required this.progressPercentage,
    required this.containerColor
  });

  static List<OverallStatusModel> overallStatus = [
    OverallStatusModel(
      icon: SvgPicture.asset('assets/fire.svg'),
      title: 'Calories loss',
      subtitle: '12.183Kcal',
      gain: '+2.8%',
      progressPercentage: '37%', 
      containerColor: Color(0xffffdab5),
    ),
    OverallStatusModel(
      icon: SvgPicture.asset('assets/fire.svg'),
      title: 'Weight loss',
      subtitle: '10.57Kg',
      gain: '+2.8%',
      progressPercentage: '80%', 
      containerColor: Color(0xffe9eaec),
    ),
  ];

}