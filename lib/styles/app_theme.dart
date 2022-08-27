// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: _AppDarkColors.blue,
    colorScheme: ThemeData.light().colorScheme.copyWith(
          secondary: _AppLightColors.blue,
          onSecondary: _AppLightColors.white,
        ),
    dividerColor: _AppLightColors.supportSeparator,
    toggleableActiveColor: _AppLightColors.blue,
    errorColor: _AppLightColors.red,
    scaffoldBackgroundColor: _AppLightColors.backPrimary,
    cardColor: _AppLightColors.backSecondary,
    appBarTheme: const AppBarTheme(
      backgroundColor: _AppLightColors.backPrimary,
      iconTheme: IconThemeData(
        color: _AppLightColors.textLabelPrimary,
      ),
    ),
    iconTheme: const IconThemeData(
      color: _AppLightColors.textLabelTertiary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: GoogleFonts.roboto(
        textStyle: const TextStyle(
          color: _AppLightColors.textLabelTertiary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(
        _AppLightColors.supportSeparator,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      splashRadius: 24,
    ),
    textTheme: _AppTextTheme.textTheme.apply(
      bodyColor: _AppLightColors.textLabelPrimary,
      displayColor: _AppLightColors.textLabelPrimary,
    ),
    extensions: [
      AppLightTextStyle(),
    ],
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: _AppDarkColors.blue,
    colorScheme: ThemeData.dark().colorScheme.copyWith(
          secondary: _AppDarkColors.blue,
          onSecondary: _AppDarkColors.white,
        ),
    dividerColor: _AppDarkColors.supportSeparator,
    toggleableActiveColor: _AppDarkColors.blue,
    errorColor: _AppDarkColors.red,
    scaffoldBackgroundColor: _AppDarkColors.backPrimary,
    cardColor: _AppDarkColors.backSecondary,
    appBarTheme: const AppBarTheme(
      backgroundColor: _AppDarkColors.backPrimary,
      iconTheme: IconThemeData(
        color: _AppDarkColors.textLabelPrimary,
      ),
    ),
    iconTheme: const IconThemeData(
      color: _AppDarkColors.textLabelTertiary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: GoogleFonts.roboto(
        textStyle: const TextStyle(
          color: _AppDarkColors.textLabelTertiary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(
        _AppDarkColors.supportSeparator,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      splashRadius: 24,
    ),
    textTheme: _AppTextTheme.textTheme.apply(
      bodyColor: _AppDarkColors.textLabelPrimary,
      displayColor: _AppDarkColors.textLabelPrimary,
    ),
    extensions: [
      AppDarkTextStyle(),
    ],
  );
}

abstract class _AppTextTheme {
  static final TextTheme textTheme = TextTheme(
    titleLarge: GoogleFonts.roboto(
      textStyle: const TextStyle(
        //  color: _AppLightColors.textLabelPrimary,
        fontSize: 38,
        fontWeight: FontWeight.w500,
      ),
    ),
    titleMedium: GoogleFonts.roboto(
      textStyle: const TextStyle(
        //   color: _AppLightColors.textLabelPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
    headlineLarge: GoogleFonts.roboto(
      textStyle: const TextStyle(
        //  color: _AppLightColors.textLabelPrimary,
        fontSize: 32,
        fontWeight: FontWeight.w500,
      ),
    ),
    headlineMedium: GoogleFonts.roboto(
      textStyle: const TextStyle(
        //    color: _AppLightColors.textLabelPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    bodyLarge: GoogleFonts.roboto(
      textStyle: const TextStyle(
        //   color: _AppLightColors.textLabelPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
    ),
    bodyMedium: GoogleFonts.roboto(
      textStyle: const TextStyle(
        //  color: _AppLightColors.textLabelPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
    bodySmall: GoogleFonts.roboto(
      textStyle: const TextStyle(
        //   color: _AppLightColors.textLabelTertiary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
    labelMedium: GoogleFonts.roboto(
      textStyle: const TextStyle(
        //   color: _AppLightColors.textLabelPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
    ),
    labelSmall: GoogleFonts.roboto(
      textStyle: const TextStyle(
        // color: _AppLightColors.textLabelTertiary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}

abstract class AppColors {
  static Color red = const Color.fromARGB(255, 207, 10, 161);
  static Color green = const Color(0xFF34C759);
  static Color blue = const Color(0xFF007AFF);
}

// abstract class AppTextStyle {
//   static const TextStyle crossedOut = TextStyle(
//     color: _AppLightColors.textLabelTertiary,
//     fontSize: 16,
//     fontWeight: FontWeight.w400,
//     decoration: TextDecoration.lineThrough,
//   );
// }
class AppLightTextStyle extends AppTextStyle {
  AppLightTextStyle()
      : super(
          crossedOut: const TextStyle(
            color: _AppLightColors.textLabelTertiary,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.lineThrough,
          ),
          subtitle: const TextStyle(
            color: _AppLightColors.textLabelTertiary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        );
}

class AppDarkTextStyle extends AppTextStyle {
  AppDarkTextStyle()
      : super(
          crossedOut: const TextStyle(
            color: _AppDarkColors.textLabelTertiary,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.lineThrough,
          ),
          subtitle: const TextStyle(
            color: _AppDarkColors.textLabelTertiary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        );
}

class AppTextStyle extends ThemeExtension<AppTextStyle> {
  AppTextStyle({
    required this.crossedOut,
    required this.subtitle,
  });

  TextStyle? crossedOut;
  TextStyle? subtitle;

  @override
  ThemeExtension<AppTextStyle> copyWith({
    TextStyle? crossedOut,
    TextStyle? subtitle,
  }) {
    return AppTextStyle(
      crossedOut: crossedOut ?? this.crossedOut,
      subtitle: subtitle ?? this.subtitle,
    );
  }

  @override
  ThemeExtension<AppTextStyle> lerp(
    ThemeExtension<AppTextStyle>? other,
    double t,
  ) {
    if (other is! AppTextStyle) {
      return this;
    }
    return AppTextStyle(
      crossedOut: TextStyle.lerp(crossedOut, other.crossedOut, t),
      subtitle: TextStyle.lerp(subtitle, other.subtitle, t),
    );
  }
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

abstract class _AppDarkColors {
  static const Color red = Color(0xFFFF3B30);
  static const Color green = Color(0xFF34C759);
  static const Color blue = Color(0xFF007AFF);
  static const Color gray = Color(0xFF8E8E93);
  static const Color grayLight = Color(0xFF48484A);
  static const Color white = Color(0xFFFFFFFF);

  static const Color textLabelPrimary = Color(0xFFFFFFFF);
  static const Color textLabelSecondary = Color(0x99FFFFFF);
  static const Color textLabelTertiary = Color(0x66FFFFFF);
  static const Color textLabelDisable = Color(0x26FFFFFF);

  static const Color backPrimary = Color(0xFF161618);
  static const Color backSecondary = Color(0xFF252528);
  static const Color backElevated = Color(0xFF3C3C3F);

  static const Color supportSeparator = Color(0x33FFFFFF);
  static const Color supportOverlay = Color(0x52000000);
}
