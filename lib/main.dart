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
      .ensureInitialized(); // Ensures that the Flutter environment is properly initialized

  await Hive.initFlutter(); // Initializes Hive for Flutter
  Hive.registerAdapter(
      RecipeAdapter()); // Registers the adapter for the Recipe model
  await Hive.openBox<Recipe>(
      'recipes'); // Opens the box that contains the recipes
  await Hive.openBox(
      'settings'); // Opens the box for settings (like theme, etc.)

  // Starts the application with a provider for theme switching
  runApp(
    ChangeNotifierProvider(
      create: (_) =>
          ThemeNotifier(), // Provides the ThemeNotifier to the entire app
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier =
        Provider.of<ThemeNotifier>(context); // Access to the current theme

    return MaterialApp(
      title: 'Cooking Recipes',
      debugShowCheckedModeBanner: false, // Hides the debug banner
      theme: AppTheme.light, // Light mode theme
      darkTheme: AppTheme.dark, // Dark mode theme
      themeMode: themeNotifier
          .themeMode, // Theme selection by user (light/dark/system)

      // Support for Greek and English translations
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('el', ''), // Greek
        Locale('en', ''), // English
      ],

      // Define routes for navigation
      routes: {
        '/': (context) => const HomeScreen(), // Home screen
        '/add': (context) =>
            const AddRecipeScreen(), // Screen for adding a recipe
      },
    );
  }
}
