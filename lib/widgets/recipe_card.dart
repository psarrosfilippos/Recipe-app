import 'dart:io';
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'star_rating.dart';

// Card widget that displays the basic information of a recipe
class RecipeCard extends StatelessWidget {
  final Recipe recipe; // The recipe object to be displayed
  final VoidCallback?
      onTap; // Function executed when the user taps the card

  const RecipeCard({super.key, required this.recipe, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Select appropriate image (or icon) for the card
    Widget imageWidget;

    if (recipe.imagePath.isEmpty) {
      // If there is no image, show a placeholder icon
      imageWidget =
          const Icon(Icons.image_not_supported, size: 80, color: Colors.grey);
    } else if (recipe.imagePath.startsWith('/')) {
      // If it's a local file (e.g. from gallery)
      imageWidget = Image.file(
        File(recipe.imagePath),
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      );
    } else {
      // If it's an asset from the assets folder
      imageWidget = Image.asset(
        recipe.imagePath,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      );
    }

    return Hero(
      // Used for transition animation to the detail screen
      tag: recipe.title,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: InkWell(
          onTap: onTap, // Trigger onTap callback when card is tapped
          borderRadius: BorderRadius.circular(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: imageWidget,
              ),
              const SizedBox(width: 12),
              // Recipe information
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipe title
                      Text(
                        recipe.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Difficulty
                      Text('Difficulty: ${recipe.difficulty}'),
                      // Preparation time
                      Text('Time: ${recipe.prepTime} minutes'),
                      const SizedBox(height: 6),
                      // Star rating
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

