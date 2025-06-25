import 'package:flutter/material.dart';

class GlobalColors {
  static const primaryBlue = Color(0xff1d329d);
  static const primaryColor = Color(0xff2EC4B6);
  static const primaryColorLight = Color(0xffCBF3F0);
  // static const primaryColor = Colors.greenAccent;
  // static const primaryColorLight = Color.fromARGB(255, 144, 236, 192);

  static const Color primaryGreen = Color(0xff204c27);
  static const lightGreen = Color(0xff22c55e);
  static const borderColor = Color(0xffd1d5db);
  static const teal = Color(0xff6fffe9);
  static const purple = Color(0xff7064e3);
  static const glowGreen = Color.fromARGB(255, 95, 234, 118);
  

  static Color? containerThemeColor(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark? Colors.grey[900]!.withOpacity(.5) : Colors.white;
  }

  static Color? containerColor(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark? Colors.grey[900] : Colors.white;
  }

  static Color? textThemeColor(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark? Colors.white : Colors.black;
  }

  static Color? shadowColor(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark? Colors.transparent : Colors.grey;
  }

  static List<BoxShadow> boxShadow(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return [
      BoxShadow(
        color: isDark? Colors.transparent : Colors.grey.withOpacity(0.1),
        spreadRadius: 1,
        blurRadius: 5,
        offset: const Offset(0, 5),
      ),
    ];
  }
}