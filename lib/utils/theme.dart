import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primaryLight,
    scaffoldBackgroundColor: AppColors.bgLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryLight,
      secondary: AppColors.secondaryLight,
      surface: AppColors.cardLight,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textLight,
    ),
    textTheme: GoogleFonts.hindSiliguriTextTheme(ThemeData.light().textTheme).copyWith(
      displayLarge: GoogleFonts.hindSiliguri(
        color: AppColors.textLight,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.hindSiliguri(
        color: AppColors.textLight,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: GoogleFonts.hindSiliguri(
        color: AppColors.textLight,
        fontSize: 16,
      ),
      bodyMedium: GoogleFonts.hindSiliguri(
        color: AppColors.textMutedLight,
        fontSize: 14,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardLight,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bgLight,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: AppColors.textLight),
      titleTextStyle: GoogleFonts.hindSiliguri(
        color: AppColors.textLight,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.cardLight,
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: AppColors.textMutedLight,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.bgDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      secondary: AppColors.secondaryDark,
      surface: AppColors.cardDark,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textDark,
    ),
    textTheme: GoogleFonts.hindSiliguriTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.hindSiliguri(
        color: AppColors.textDark,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.hindSiliguri(
        color: AppColors.textDark,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: GoogleFonts.hindSiliguri(
        color: AppColors.textDark,
        fontSize: 16,
      ),
      bodyMedium: GoogleFonts.hindSiliguri(
        color: AppColors.textMutedDark,
        fontSize: 14,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardDark,
      elevation: 4,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bgDark,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: AppColors.textDark),
      titleTextStyle: GoogleFonts.hindSiliguri(
        color: AppColors.textDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.cardDark,
      selectedItemColor: AppColors.primaryDark,
      unselectedItemColor: AppColors.textMutedDark,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
}
