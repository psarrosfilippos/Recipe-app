import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// Class that manages the app's theme and notifies widgets when it changes
class ThemeNotifier extends ChangeNotifier {
  // The key used to store the theme preference in Hive
  static const _themeKey = 'themeMode';

  // The variable that stores the current theme
  late ThemeMode _themeMode;

  // Constructor that reads the saved value from Hive at startup
  ThemeNotifier() {
    final box = Hive.box('settings');
    final saved =
        box.get(_themeKey, defaultValue: 'system'); // default = system
    _themeMode =
        _getThemeModeFromString(saved); // Convert string -> ThemeMode
  }

  // Returns the current ThemeMode
  ThemeMode get themeMode => _themeMode;

  // Boolean to check if dark mode is enabled
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Toggles the theme and stores the new preference
  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;

    // Stores the user's choice in Hive
    Hive.box('settings').put(_themeKey, _themeMode.name);

    // Notifies all listening widgets that the theme has changed
    notifyListeners();
  }

  // Private method that converts a string to ThemeMode
  ThemeMode _getThemeModeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}

