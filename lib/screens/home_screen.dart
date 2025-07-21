// Import required packages
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import 'add_recipe_screen.dart';
import 'recipe_detail_screen.dart';
import '../theme/theme_notifier.dart';

// Main screen displaying the recipes
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Recipe> recipes = []; // List of recipes
  String sortOption = 'Χρόνος'; // Sorting option (default: Time)

  @override
  void initState() {
    super.initState();
    final box = Hive.box<Recipe>('recipes'); // Open the Hive box
    recipes = box.values.toList().cast<Recipe>(); // Retrieve all recipes
    _sortRecipes(); // Initial sorting
  }

  // Navigate to the add new recipe screen
  void _goToAddRecipe() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
    );

    // After returning, refresh the list
    setState(() {
      recipes = Hive.box<Recipe>('recipes').values.toList().cast<Recipe>();
      _sortRecipes();
    });
  }

  // Navigate to the recipe detail page
  void _goToRecipeDetail(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  // Sort recipes based on the selected category
  void _sortRecipes() {
    if (sortOption == 'Χρόνος') {
      recipes.sort((a, b) => a.prepTime.compareTo(b.prepTime));
    } else if (sortOption == 'Βαθμολογία') {
      recipes.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (sortOption == 'Δυσκολία') {
      final levels = {'Εύκολη': 1, 'Μέτρια': 2, 'Δύσκολη': 3};
      recipes.sort(
        (a, b) => levels[a.difficulty]!.compareTo(levels[b.difficulty]!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier =
        Provider.of<ThemeNotifier>(context); // For changing theme

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange,
        title: const Text(
          'My Recipes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Sorting menu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: PopupMenuButton<String>(
              onSelected: (String newValue) {
                setState(() {
                  sortOption = newValue;
                  _sortRecipes();
                });
              },
              itemBuilder: (BuildContext context) => const [
                PopupMenuItem(value: 'Χρόνος', child: Text('Time')),
                PopupMenuItem(value: 'Βαθμολογία', child: Text('Rating')),
                PopupMenuItem(value: 'Δυσκολία', child: Text('Difficulty')),
              ],
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  border: Border.all(color: Colors.white70),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.swap_vert, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      sortOption,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Theme switch button (light/dark)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Consumer<ThemeNotifier>(
              builder: (context, notifier, _) {
                return GestureDetector(
                  onTap: () {
                    notifier.toggleTheme(!notifier.isDarkMode);
                  },
                  child: Container(
                    width: 42,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(0.3),
                    ),
                    child: Icon(
                      notifier.isDarkMode ? Icons.nightlight : Icons.wb_sunny,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Display the list of recipes
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];

          return Dismissible(
            key: Key('${recipe.key}_$index'),
            background: Container(
              color: Colors.red,
              padding: const EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction:
                DismissDirection.startToEnd, // Delete with swipe to the right
            onDismissed: (direction) async {
              final deletedRecipe = recipe;

              // Temporarily remove from list
              setState(() {
                recipes.removeAt(index);
              });

              final scaffold = ScaffoldMessenger.of(context);
              bool undoClicked = false;

              // Show Snackbar with undo option
              scaffold.showSnackBar(
                SnackBar(
                  content: Text('Recipe deleted: ${deletedRecipe.title}'),
                  duration: const Duration(seconds: 3),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      undoClicked = true;
                      setState(() {
                        recipes.insert(index, deletedRecipe);
                        _sortRecipes();
                      });
                    },
                  ),
                ),
              );

              // Wait for snackbar to finish, delete permanently if undo not clicked
              await Future.delayed(const Duration(seconds: 3));

              if (!undoClicked) {
                await deletedRecipe.delete();
              }
            },

            // On card tap, open recipe details
            child: GestureDetector(
              onTap: () => _goToRecipeDetail(recipe),
              child: RecipeCard(recipe: recipe), // Recipe display card
            ),
          );
        },
      ),

      // Button to add new recipe
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddRecipe,
        child: const Icon(Icons.add),
      ),
    );
  }
}
