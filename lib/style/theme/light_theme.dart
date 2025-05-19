import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_tracker/style/colour_scheme/light_color_scheme.dart';

final lightTheme = ThemeData.light(useMaterial3: true).copyWith(
  colorScheme: lightColorScheme,
  scaffoldBackgroundColor: Color(0xffeeeef0),
  appBarTheme: AppBarTheme(backgroundColor: Color(0xffeeeef0)),
  textTheme: TextTheme(
    displayMedium: GoogleFonts.lilitaOne(),
    displayLarge: GoogleFonts.lilitaOne(),
    displaySmall: GoogleFonts.lilitaOne(),
    headlineLarge: GoogleFonts.dmSans(color: Colors.black),
    headlineMedium: GoogleFonts.dmSans(color: Colors.black),
    headlineSmall: GoogleFonts.dmSans(color: Colors.black),
    bodyLarge: GoogleFonts.dmSans(color: Colors.black),
    bodySmall: GoogleFonts.dmSans(color: Colors.black),
    bodyMedium: GoogleFonts.dmSans(color: Colors.black),
  )
);