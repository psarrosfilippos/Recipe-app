import 'dart:io';
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'star_rating.dart';

// Widget κάρτας που εμφανίζει τις βασικές πληροφορίες μιας συνταγής
class RecipeCard extends StatelessWidget {
  final Recipe recipe; // Το αντικείμενο της συνταγής που θα εμφανιστεί
  final VoidCallback?
      onTap; // Συνάρτηση που εκτελείται όταν ο χρήστης πατήσει την κάρτα

  const RecipeCard({super.key, required this.recipe, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Επιλογή κατάλληλης εικόνας (ή εικονιδίου) για την κάρτα
    Widget imageWidget;

    if (recipe.imagePath.isEmpty) {
      // Αν δεν υπάρχει εικόνα, εμφάνισε εικονίδιο placeholder
      imageWidget =
          const Icon(Icons.image_not_supported, size: 80, color: Colors.grey);
    } else if (recipe.imagePath.startsWith('/')) {
      // Αν είναι αρχείο τοπικό (π.χ. από gallery)
      imageWidget = Image.file(
        File(recipe.imagePath),
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      );
    } else {
      // Αν είναι asset από τον φάκελο assets
      imageWidget = Image.asset(
        recipe.imagePath,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      );
    }

    return Hero(
      // Χρησιμοποιείται για animation κατά τη μετάβαση στην οθόνη λεπτομερειών
      tag: recipe.title,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: InkWell(
          onTap: onTap, // Ενεργοποίηση onTap callback όταν πατιέται η κάρτα
          borderRadius: BorderRadius.circular(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Η εικόνα της συνταγής
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: imageWidget,
              ),
              const SizedBox(width: 12),
              // Οι πληροφορίες της συνταγής
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Τίτλος της συνταγής
                      Text(
                        recipe.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Δυσκολία
                      Text('Δυσκολία: ${recipe.difficulty}'),
                      // Χρόνος προετοιμασίας
                      Text('Χρόνος: ${recipe.prepTime} λεπτά'),
                      const SizedBox(height: 6),
                      // Βαθμολογία με αστέρια
                      StarRating(rating: recipe.rating),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
