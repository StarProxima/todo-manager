// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  static final ThemeData _lightTheme = ThemeData(
    primaryColor: _AppLightColors.blue,
    scaffoldBackgroundColor: _AppLightColors.backPrimary,
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(
        _AppLightColors.supportSeparator,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      splashRadius: 24,
    ),
    textTheme: _textTheme,
  );

  static final TextTheme _textTheme = TextTheme(
    titleLarge: GoogleFonts.roboto(
      textStyle: const TextStyle(
        color: _AppLightColors.textLabelPrimary,
        fontSize: 38,
        fontWeight: FontWeight.w500,
      ),
    ),
    titleMedium: GoogleFonts.roboto(
      textStyle: const TextStyle(
        color: _AppLightColors.textLabelPrimary,
        fontSize: 32,
        fontWeight: FontWeight.w500,
      ),
    ),
    headlineLarge: GoogleFonts.roboto(
      textStyle: const TextStyle(
        color: _AppLightColors.textLabelPrimary,
        fontSize: 32,
        fontWeight: FontWeight.w500,
      ),
    ),
    headlineMedium: GoogleFonts.roboto(
      textStyle: const TextStyle(
        color: _AppLightColors.textLabelPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    bodyLarge: GoogleFonts.roboto(
      textStyle: const TextStyle(
        color: _AppLightColors.textLabelPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
    ),
    bodyMedium: GoogleFonts.roboto(
      textStyle: const TextStyle(
        color: _AppLightColors.textLabelPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
    labelMedium: GoogleFonts.roboto(
      textStyle: const TextStyle(
        color: _AppLightColors.textLabelPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
    ),
    labelSmall: GoogleFonts.roboto(
      textStyle: const TextStyle(
        color: _AppLightColors.textLabelTertiary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
  static ThemeData get themeData => _lightTheme;
}

abstract class AppColors {
  static const Color red = Color(0xFFFF3B30);
  static const Color green = Color(0xFF34C759);
  static const Color blue = Color(0xFF007AFF);
}

abstract class AppTextStyle {
  static const TextStyle crossedOut = TextStyle(
    color: _AppLightColors.textLabelTertiary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.lineThrough,
  );
}

abstract class _AppLightColors {
  static const Color red = Color(0xFFFF3B30);
  static const Color green = Color(0xFF34C759);
  static const Color blue = Color(0xFF007AFF);
  static const Color gray = Color(0xFF8E8E93);
  static const Color grayLight = Color(0xFFD1D1D6);
  static const Color white = Color(0xFFFFFFFF);

  static const Color textLabelPrimary = Color(0xFF000000);
  static const Color textLabelSecondary = Color(0x99000000);
  static const Color textLabelTertiary = Color(0x4D000000);
  static const Color textLabelDisable = Color(0x26000000);

  static const Color backPrimary = Color(0xFFF7F6F2);
  static const Color backSecondary = Color(0xFFFFFFFF);
  static const Color backElevated = Color(0xFFFFFFFF);

  static const Color supportSeparator = Color(0x33000000);
  static const Color supportOverlay = Color(0x0F000000);
}
