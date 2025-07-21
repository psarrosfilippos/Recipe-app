import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// Κλάση που διαχειρίζεται το θέμα της εφαρμογής και ειδοποιεί τα widgets όταν αλλάζει
class ThemeNotifier extends ChangeNotifier {
  // Το κλειδί που χρησιμοποιείται για την αποθήκευση της προτίμησης θέματος στη Hive
  static const _themeKey = 'themeMode';

  // Η μεταβλητή που αποθηκεύει το τρέχον θέμα
  late ThemeMode _themeMode;

  // Constructor που διαβάζει την αποθηκευμένη τιμή από τη Hive κατά την εκκίνηση
  ThemeNotifier() {
    final box = Hive.box('settings');
    final saved =
        box.get(_themeKey, defaultValue: 'system'); // default = system
    _themeMode =
        _getThemeModeFromString(saved); // Μετατροπή string -> ThemeMode
  }

  // Επιστρέφει το τρέχον ThemeMode
  ThemeMode get themeMode => _themeMode;

  // Boolean για να ελέγχει αν είναι ενεργοποιημένο το dark mode
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Εναλλάσσει το θέμα και αποθηκεύει τη νέα προτίμηση
  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;

    // Αποθηκεύει την επιλογή του χρήστη στο Hive
    Hive.box('settings').put(_themeKey, _themeMode.name);

    // Ειδοποιεί όλα τα widgets που κάνουν listen ότι το θέμα άλλαξε
    notifyListeners();
  }

  // Ιδιωτική μέθοδος που μετατρέπει string σε ThemeMode
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
