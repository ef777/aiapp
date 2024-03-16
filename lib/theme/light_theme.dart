import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData light = ThemeData(
  fontFamily: 'Poppins',
  primaryColor: Color(0xff316064),
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  focusColor: Color(0xFFADC4C8),
  textTheme: TextTheme(
    bodyMedium: GoogleFonts.baloo2(
      color: Color(0xff316064),
      fontWeight: FontWeight.w600,
      fontSize: 22,
    ),
    bodySmall: GoogleFonts.baloo2(
      color: Color(0xff316064),
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
    bodyLarge: GoogleFonts.baloo2(
      color: Color(0xff316064),
      fontWeight: FontWeight.w700,
      fontSize: 26,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    focusColor: Color(0xff4468EC),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color: Color(0xffDFDFDF),
      ),
    ),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Color(0xffDFDFDF))),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Color(0xff316064), width: 2)),
    contentPadding: EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 12,
    ),
    hintStyle: GoogleFonts.inter(
      fontWeight: FontWeight.w400,
      fontSize: 17,
      color: Color(0xffCBCBCB),
    ),
  ),
  appBarTheme: AppBarTheme(
      toolbarHeight: 76,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.poppins(
        color: Color(0xff316064),
        fontSize: 24,
        fontWeight: FontWeight.w600,
      )),
  hintColor: Color(0xFF52575C),
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);
