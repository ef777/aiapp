import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Poppins',
  primaryColor: Color(0xFF82CAB6),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF12151B),
  accentColor: Color(0xFF121212),
  hintColor: Color(0xFFE7F6F8),
  focusColor: Color(0xFFADC4C8),
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xff1B2029),
      focusColor: Color(0xff4468EC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: 20  ,
        horizontal: 12,
      ),
      hintStyle: GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 17,
        color: Color(0xffCBCBCB),
      ),
    ),
  textTheme: TextTheme(
    titleSmall: GoogleFonts.josefinSans(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 22,
    ),
    bodySmall: GoogleFonts.josefinSans(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 22,
    ),
  )
);
