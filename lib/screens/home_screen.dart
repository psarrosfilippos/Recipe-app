// Εισαγωγή των απαραίτητων πακέτων
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import 'add_recipe_screen.dart';
import 'recipe_detail_screen.dart';
import '../theme/theme_notifier.dart';

// Κύρια οθόνη εμφάνισης των συνταγών
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Recipe> recipes = []; // Λίστα με τις συνταγές
  String sortOption = 'Χρόνος'; // Επιλογή ταξινόμησης (default: Χρόνος)

  @override
  void initState() {
    super.initState();
    final box = Hive.box<Recipe>('recipes'); // Άνοιγμα του Hive box
    recipes = box.values.toList().cast<Recipe>(); // Ανάκτηση όλων των συνταγών
    _sortRecipes(); // Αρχική ταξινόμηση
  }

  // Πλοήγηση στην οθόνη προσθήκης νέας συνταγής
  void _goToAddRecipe() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
    );

    // Μετά την επιστροφή, ανανέωση της λίστας
    setState(() {
      recipes = Hive.box<Recipe>('recipes').values.toList().cast<Recipe>();
      _sortRecipes();
    });
  }

  // Πλοήγηση στη σελίδα λεπτομερειών συνταγής
  void _goToRecipeDetail(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  // Ταξινόμηση συνταγών ανάλογα με την επιλεγμένη κατηγορία
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
        Provider.of<ThemeNotifier>(context); // Για αλλαγή θέματος

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange,
        title: const Text(
          'Οι Συνταγές μου',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Μενού επιλογής ταξινόμησης
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
                PopupMenuItem(value: 'Χρόνος', child: Text('Χρόνος')),
                PopupMenuItem(value: 'Βαθμολογία', child: Text('Βαθμολογία')),
                PopupMenuItem(value: 'Δυσκολία', child: Text('Δυσκολία')),
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

          // Κουμπί αλλαγής θέματος (φως/σκοτάδι)
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

      // Εμφάνιση της λίστας των συνταγών
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
                DismissDirection.startToEnd, // Διαγραφή με swipe προς τα δεξιά
            onDismissed: (direction) async {
              final deletedRecipe = recipe;

              // Αφαίρεση από τη λίστα προσωρινά
              setState(() {
                recipes.removeAt(index);
              });

              final scaffold = ScaffoldMessenger.of(context);
              bool undoClicked = false;

              // Εμφάνιση Snackbar με επιλογή αναίρεσης
              scaffold.showSnackBar(
                SnackBar(
                  content: Text('Διαγράφηκε η συνταγή: ${deletedRecipe.title}'),
                  duration: const Duration(seconds: 3),
                  action: SnackBarAction(
                    label: 'ΑΝΑΙΡΕΣΗ',
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

              // Περιμένει να τελειώσει το snackbar και αν δεν πατήθηκε αναίρεση διαγράφει οριστικά
              await Future.delayed(const Duration(seconds: 3));

              if (!undoClicked) {
                await deletedRecipe.delete();
              }
            },

            // Πατώντας την κάρτα ανοίγουν οι λεπτομέρειες
            child: GestureDetector(
              onTap: () => _goToRecipeDetail(recipe),
              child: RecipeCard(recipe: recipe), // Κάρτα εμφάνισης συνταγής
            ),
          );
        },
      ),

      // Κουμπί για προσθήκη νέας συνταγής
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddRecipe,
        child: const Icon(Icons.add),
      ),
    );
  }
}
