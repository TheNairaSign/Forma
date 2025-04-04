import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: Color(0xfff7f7f7),
  appBarTheme: AppBarTheme(backgroundColor: Colors.white),
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