import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_tracker/style/colour_scheme/light_color_scheme.dart';

final darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
  colorScheme: darkColorScheme,
  textTheme: TextTheme(
    displayMedium: GoogleFonts.lilitaOne(),
    displayLarge: GoogleFonts.lilitaOne(),
    displaySmall: GoogleFonts.lilitaOne(),
    headlineLarge: GoogleFonts.dmSans(),
    headlineMedium: GoogleFonts.dmSans(),
    headlineSmall: GoogleFonts.dmSans(),
    bodyLarge: GoogleFonts.dmSans(),
    bodySmall: GoogleFonts.dmSans(),
    bodyMedium: GoogleFonts.dmSans(),
  )
);