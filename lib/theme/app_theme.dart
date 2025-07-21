import 'package:flutter/material.dart';

// Κλάση που ορίζει τα θέματα (light & dark) για όλη την εφαρμογή
class AppTheme {
  // Ο κύριος χρωματικός τόνος της εφαρμογής
  static const primaryColor = Colors.orange;

  // Θέμα για light mode
  static final light = ThemeData(
    brightness: Brightness.light, // Φωτεινό θέμα
    primarySwatch: primaryColor, // Χρώμα προτεραιότητας (π.χ. κουμπιά, AppBar)
    scaffoldBackgroundColor: Colors.white, // Χρώμα φόντου οθονών

    // Ρυθμίσεις AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white, // Χρώμα κειμένου/εικονιδίων στο AppBar
    ),

    // Θέματα για κείμενο
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16), // Κανονικό κείμενο
      titleMedium:
          TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Τίτλοι
    ),

    // Ρυθμίσεις για κάρτες (όπως οι κάρτες συνταγών)
    cardTheme: const CardTheme(
      color: Colors.white, // Φόντο της κάρτας
      elevation: 4, // Σκιά (βάθος)
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6), // Περιθώριο
    ),

    // Ρύθμιση για το Floating Action Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
    ),
  );

  // Θέμα για dark mode
  static final dark = ThemeData(
    brightness: Brightness.dark, // Σκοτεινό θέμα
    primarySwatch: primaryColor,
    scaffoldBackgroundColor: const Color(0xFF121212), // Φόντο με σκούρο γκρι

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),

    cardTheme: const CardTheme(
      color: Color(0xFF1E1E1E), // Σκούρο φόντο για κάρτες
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
    ),
  );
}
