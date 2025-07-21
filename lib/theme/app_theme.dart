import 'package:flutter/material.dart';

// Class that defines the themes (light & dark) for the entire application
class AppTheme {
  // The main color tone of the application
  static const primaryColor = Colors.orange;

  // Theme for light mode
  static final light = ThemeData(
    brightness: Brightness.light, // Light theme
    primarySwatch: primaryColor, // Primary color (e.g. buttons, AppBar)
    scaffoldBackgroundColor: Colors.white, // Background color for screens

    // AppBar settings
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white, // Text/icon color in AppBar
    ),

    // Text theme settings
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16), // Regular text
      titleMedium:
          TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Titles
    ),

    // Card settings (e.g. recipe cards)
    cardTheme: const CardTheme(
      color: Colors.white, // Card background
      elevation: 4, // Shadow depth
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6), // Margin
    ),

    // Floating Action Button settings
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
    ),
  );

  // Theme for dark mode
  static final dark = ThemeData(
    brightness: Brightness.dark, // Dark theme
    primarySwatch: primaryColor,
    scaffoldBackgroundColor: const Color(0xFF121212), // Dark gray background

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),

    cardTheme: const CardTheme(
      color: Color(0xFF1E1E1E), // Dark background for cards
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
    ),
  );
}
