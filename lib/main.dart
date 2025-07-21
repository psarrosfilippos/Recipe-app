import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/recipe.dart';
import 'screens/home_screen.dart';
import 'screens/add_recipe_screen.dart';
import 'theme/app_theme.dart';
import 'theme/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Εξασφαλίζει ότι το Flutter περιβάλλον έχει αρχικοποιηθεί σωστά

  await Hive.initFlutter(); // Αρχικοποιεί το Hive για Flutter
  Hive.registerAdapter(
      RecipeAdapter()); // Καταχώρηση του adapter για το μοντέλο Recipe
  await Hive.openBox<Recipe>(
      'recipes'); // Άνοιγμα του κουτιού (box) που περιέχει τις συνταγές
  await Hive.openBox(
      'settings'); // Άνοιγμα του κουτιού για ρυθμίσεις (όπως θέμα κ.ά.)

  // Εκκίνηση της εφαρμογής με πάροχο για την αλλαγή θέματος
  runApp(
    ChangeNotifierProvider(
      create: (_) =>
          ThemeNotifier(), // Παροχή του ThemeNotifier σε ολόκληρη την εφαρμογή
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier =
        Provider.of<ThemeNotifier>(context); // Πρόσβαση στο current theme

    return MaterialApp(
      title: 'Συνταγές Μαγειρικής',
      debugShowCheckedModeBanner: false, // Απόκρυψη του debug banner
      theme: AppTheme.light, // Θέμα φωτεινής λειτουργίας
      darkTheme: AppTheme.dark, // Θέμα σκοτεινής λειτουργίας
      themeMode: themeNotifier
          .themeMode, // Επιλογή θέματος από τον χρήστη (light/dark/system)

      // Υποστήριξη ελληνικών και αγγλικών μεταφράσεων
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('el', ''), // Ελληνικά
        Locale('en', ''), // Αγγλικά
      ],

      // Ορισμός routes για την πλοήγηση
      routes: {
        '/': (context) => const HomeScreen(), // Αρχική οθόνη
        '/add': (context) =>
            const AddRecipeScreen(), // Οθόνη προσθήκης συνταγής
      },
    );
  }
}
