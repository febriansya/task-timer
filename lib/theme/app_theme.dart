import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Define your custom colors
  static const Color primaryColor = Color(0xFF3A86FF); // biru
  static const Color secondaryColor = Color(0xFF9D4EDD); // ungu
  static const Color accentColor = Color(0xFFFFC107); // kuning
  static const Color backgroundColor = Color(0xFF121212); // dark background
  static const Color textPrimaryColor = Color(0xFFFFFFFF); // white text
  static const Color textSecondaryColor = Color(0xFFB3B3B3); // gray text

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: backgroundColor,
      canvasColor: backgroundColor,
      // Customize primary color
      primarySwatch: Colors.blue,
      // Customize text themes
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontFamily: GoogleFonts.inriaSans().fontFamily,
        ),
        headlineMedium: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontFamily: 'InriaSans',
        ),
        headlineSmall: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontFamily: 'InriaSans',
        ),
        bodyLarge: TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
          fontFamily: 'InriaSans',
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          color: Colors.black87,
          fontFamily: 'InriaSans',
        ),
        labelLarge: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
          fontFamily: 'InriaSans',
        ),
      ),
      // Customize app bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'InriaSans',
        ),
        centerTitle: true,
      ),
      // Customize button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'InriaSans',
          ),
        ),
      ),
      // Customize floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.black,
      ),
      // Customize input field theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: primaryColor, width: 2.0),
        ),
      ),
      // Customize card theme
      cardTheme: const CardThemeData(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        surface: backgroundColor,
      ),
      // Customize background
      scaffoldBackgroundColor: backgroundColor,
      canvasColor: backgroundColor,
      // Customize text themes with your specified colors
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
          fontFamily: 'InriaSans',
        ),
        headlineMedium: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
          fontFamily: 'InriaSans',
        ),
        headlineSmall: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
          fontFamily: 'InriaSans',
        ),
        bodyLarge: TextStyle(
          fontSize: 16.0,
          color: textPrimaryColor,
          fontFamily: 'InriaSans',
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          color: textSecondaryColor,
          fontFamily: 'InriaSans',
        ),
        labelLarge: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
          fontFamily: 'InriaSans',
        ),
      ),
      // Customize app bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: secondaryColor,
        foregroundColor: textPrimaryColor,
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
          fontFamily: 'InriaSans',
        ),
        centerTitle: true,
      ),
      // Customize button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'InriaSans',
          ),
        ),
      ),
      // Customize floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.black,
      ),
      // Customize input field theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: textSecondaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: textSecondaryColor),
        ),
        labelStyle: TextStyle(color: textSecondaryColor),
        hintStyle: TextStyle(color: textSecondaryColor),
      ),
      // Customize card theme
      cardTheme: CardThemeData(
        elevation: 4.0,
        color: secondaryColor.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          side: BorderSide(color: secondaryColor.withOpacity(0.3), width: 1.0),
        ),
      ),
      // Customize other theme elements
      primaryColor: primaryColor,
      indicatorColor: primaryColor,
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primaryColor),
      iconTheme: IconThemeData(color: textPrimaryColor),
      unselectedWidgetColor: textSecondaryColor,
    );
  }
}
