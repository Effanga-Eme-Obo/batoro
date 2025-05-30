import 'package:flutter/material.dart';

class BColors {
  BColors._();

  // Basic App Colors
  static const Color primaryColor = Color(0xff885ca6);
  static const Color secondaryColor = Color(0xffba8bff);
  static const Color accentColor = Color(0xff724cac);

  // Graadient Colors
  static const Gradient linearGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [
      Color(0xffff9a9e),
      Color(0xfffad0c4),
      Color(0xfffad8c4),
    ],
  );

  // Text Colors
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Color(0xffffffff);
  static const Color textWhite = Colors.white;

  //Background Colors
  static const Color light = Color(0xFFFBFCFE);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFF676767);

  // File Colors
  static const Color allFiles = Color(0xff9c5cfa);
  static const Color pdfFiles = Color(0xfff54a4e);
  static const Color pptFiles = Color(0xfffc872f);
  static const Color wordFiles = Color(0xff59abf8);
  static const Color excelFiles = Color(0xff3bd289);
  static const Color sheetFiles = Color(0xff4cd694);
  static const Color textFiles = Color(0xffab73b1);
  static const Color zipFiles = Color(0xfffba05d);
  static const Color bookmarkedFiles = Color(0xff5f45fc);

  // Button Colors
  static const Color buttonPrimary = Color(0xff86b359);
  static const Color buttonSecondary = Color(0xFF6C7570);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  // Border Colors
  static const Color borderPrimary = Color(0xff86b359);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  // Error & Validation Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xff93e9be);
  static const Color warning = Color(0xFFF57C00);

  // Neutral Shades
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
}