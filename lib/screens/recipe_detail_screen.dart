// Εισαγωγή βιβλιοθηκών
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../widgets/star_rating.dart';

// Οθόνη εμφάνισης λεπτομερειών μιας συνταγής
class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  // Ο constructor λαμβάνει τη συνταγή που θα προβληθεί
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    // Επιλογή του κατάλληλου widget εικόνας
    if (recipe.imagePath.isEmpty) {
      // Αν δεν υπάρχει εικόνα
      imageWidget = const Icon(
        Icons.image_not_supported,
        size: 100,
        color: Colors.grey,
      );
    } else if (recipe.imagePath.startsWith('/')) {
      // Αν είναι path από το filesystem (File image)
      imageWidget = Image.file(
        File(recipe.imagePath),
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
      );
    } else {
      // Αν είναι εικόνα asset (π.χ. bundled image)
      imageWidget = Image.asset(
        recipe.imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: true, // Επιστροφή με back button
        title: Text(
          recipe.title,
          maxLines: 2,
          overflow:
              TextOverflow.ellipsis, // Κόβει τίτλους που είναι πολύ μεγάλοι
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Scrollable περιεχόμενο
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Εικόνα με animation μετάβασης (Hero)
              Hero(
                tag: recipe.title,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageWidget,
                ),
              ),
              const SizedBox(height: 24),

              // Ενότητα υλικών
              Text(
                'Υλικά:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                recipe.ingredients.isNotEmpty
                    ? recipe.ingredients
                    : 'Δεν έχουν δηλωθεί υλικά.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Χρόνος προετοιμασίας
              Text(
                'Χρόνος προετοιμασίας: ${recipe.prepTime} λεπτά',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Δυσκολία συνταγής
              Text(
                'Δυσκολία: ${recipe.difficulty}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Βαθμολογία συνταγής με αστεράκια
              Row(
                children: [
                  const Text(
                    'Βαθμολογία: ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  StarRating(
                      rating: recipe.rating,
                      iconSize: 22), // Widget για εμφάνιση αστεριών
                ],
              ),
              const SizedBox(height: 16),

              // Εκτέλεση συνταγής
              Text(
                'Εκτέλεση:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                recipe.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
