import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Colors.black,
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